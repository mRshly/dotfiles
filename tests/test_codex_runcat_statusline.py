import importlib.util
import json
import os
import subprocess
import sys
import tempfile
import unittest
from datetime import datetime, timezone
from pathlib import Path


SCRIPT = Path(__file__).parents[1] / "private_dot_codex" / "runcat-statusline.py"
SPEC = importlib.util.spec_from_file_location("codex_runcat", SCRIPT)
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)


def token_count(total=62_000, window=258_400):
    return {
        "info": {
            "last_token_usage": {"total_tokens": total},
            "model_context_window": window,
        },
        "rate_limits": {
            "primary": {"used_percent": 3.0, "window_minutes": 300},
            "secondary": {"used_percent": 7.0, "window_minutes": 10_080},
        },
    }


class TranscriptTests(unittest.TestCase):
    def test_latest_model_and_token_count_win(self):
        records = [
            {"type": "turn_context", "payload": {"model": "gpt-old"}},
            {
                "type": "event_msg",
                "payload": {"type": "token_count", **token_count(10)},
            },
            {"type": "turn_context", "payload": {"model": "gpt-5.6-sol"}},
            {
                "type": "event_msg",
                "payload": {"type": "token_count", **token_count()},
            },
        ]
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "rollout.jsonl"
            path.write_text(
                "{broken\n" + "\n".join(json.dumps(record) for record in records),
                encoding="utf-8",
            )
            model, usage = MODULE.scan_transcript(path)

        self.assertEqual(model, "gpt-5.6-sol")
        self.assertEqual(
            usage["info"]["last_token_usage"]["total_tokens"], 62_000
        )

    def test_non_object_json_lines_are_skipped(self):
        records = [
            [],
            "unexpected",
            {"type": "turn_context", "payload": []},
            {"type": "turn_context", "payload": {"model": "gpt-5.6-sol"}},
            {
                "type": "event_msg",
                "payload": {"type": "token_count", **token_count()},
            },
        ]
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "rollout.jsonl"
            path.write_text(
                "\n".join(json.dumps(record) for record in records),
                encoding="utf-8",
            )

            model, usage = MODULE.scan_transcript(path)

        self.assertEqual(model, "gpt-5.6-sol")
        self.assertEqual(
            usage["info"]["last_token_usage"]["total_tokens"], 62_000
        )

    def test_snapshot_contains_context_and_rate_windows(self):
        now = datetime(2026, 7, 15, 8, 3, 7, tzinfo=timezone.utc)
        snapshot = MODULE.build_snapshot("gpt-5.6-sol", token_count(), now)

        self.assertEqual(snapshot["metricsBarValue"], "24%")
        self.assertEqual(
            [metric["title"] for metric in snapshot["metrics"]],
            ["Model", "Context", "5h", "7d"],
        )
        self.assertEqual(snapshot["metrics"][1]["normalizedValue"], 0.2399)
        self.assertEqual(snapshot["lastUpdatedDate"], "2026-07-15T08:03:07Z")

    def test_context_is_clamped_and_missing_limits_are_omitted(self):
        usage = token_count(total=300, window=100)
        usage["rate_limits"] = {"primary": None, "secondary": None}

        snapshot = MODULE.build_snapshot(
            "gpt", usage, datetime.now(timezone.utc)
        )

        self.assertEqual(snapshot["metricsBarValue"], "100%")
        self.assertEqual(
            [metric["title"] for metric in snapshot["metrics"]],
            ["Model", "Context"],
        )

    def test_window_label(self):
        self.assertEqual(MODULE.window_label(300), "5h")
        self.assertEqual(MODULE.window_label(1440), "1d")
        self.assertEqual(MODULE.window_label(90), "90m")
        self.assertIsNone(MODULE.window_label(None))


class MainTests(unittest.TestCase):
    def run_script(self, hook_input, output, extra_env=None):
        env = os.environ.copy()
        env["RUNCAT_OUT_FILE"] = str(output)
        env.update(extra_env or {})
        return subprocess.run(
            [sys.executable, str(SCRIPT)],
            input=json.dumps(hook_input),
            text=True,
            capture_output=True,
            env=env,
            check=False,
        )

    def test_main_writes_valid_snapshot(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            transcript = root / "rollout.jsonl"
            transcript.write_text(
                json.dumps(
                    {
                        "type": "event_msg",
                        "payload": {"type": "token_count", **token_count()},
                    }
                ),
                encoding="utf-8",
            )
            output = root / "nested" / "usage.json"

            result = self.run_script(
                {"transcript_path": str(transcript), "model": "gpt-hook"},
                output,
            )
            snapshot = json.loads(output.read_text(encoding="utf-8"))

            self.assertEqual(list(output.parent.glob(".runcat-*")), [])

        self.assertEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")
        self.assertEqual(result.stderr, "")
        self.assertEqual(
            snapshot["metrics"][0]["formattedValue"], "gpt-hook"
        )

    def test_bad_input_preserves_previous_snapshot(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "usage.json"
            output.write_text('{"keep": true}', encoding="utf-8")

            result = self.run_script({"transcript_path": "/missing"}, output)

            self.assertEqual(result.returncode, 0)
            self.assertEqual(
                output.read_text(encoding="utf-8"), '{"keep": true}'
            )


if __name__ == "__main__":
    unittest.main()
