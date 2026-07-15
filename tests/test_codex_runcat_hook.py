import json
import unittest
from pathlib import Path


class HookConfigurationTests(unittest.TestCase):
    def test_stop_hook_runs_runcat_converter(self):
        path = (
            Path(__file__).parents[1]
            / "private_dot_codex"
            / "hooks.json"
        )
        config = json.loads(path.read_text(encoding="utf-8"))
        handler = config["hooks"]["Stop"][0]["hooks"][0]

        self.assertEqual(handler["type"], "command")
        self.assertEqual(
            handler["command"],
            'python3 "$HOME/.codex/runcat-statusline.py"',
        )
        self.assertEqual(handler["timeout"], 3)


if __name__ == "__main__":
    unittest.main()
