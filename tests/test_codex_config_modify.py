import subprocess
import tomllib
import unittest
from pathlib import Path

TEMPLATE = (
    Path(__file__).parents[1] / "private_dot_codex" / "modify_private_config.toml"
)
TASK_DATA = str(Path.home() / ".local/share/task")
TOP = {
    "approval_policy": "on-request",
    "approvals_reviewer": "auto_review",
    "sandbox_mode": "workspace-write",
    "web_search": "live",
}
TOP_LINES = "".join(f'{k} = "{v}"\n' for k, v in sorted(TOP.items()))


def render(live: str) -> str:
    return subprocess.run(
        ["chezmoi", "execute-template", "--with-stdin", "--file", str(TEMPLATE)],
        input=live,
        capture_output=True,
        text=True,
        check=True,
    ).stdout


class CodexConfigModifyTests(unittest.TestCase):
    def assert_converged(self, live: str) -> str:
        out = render(live)
        cfg = tomllib.loads(out)
        for key, value in TOP.items():
            self.assertEqual(cfg[key], value, key)
        self.assertIn(TASK_DATA, cfg["sandbox_workspace_write"]["writable_roots"])
        # 2 回目の apply では何も変えない (chezmoi status が汚れない)。
        self.assertEqual(render(out), out)
        return out

    def test_prepends_top_level_keys_and_appends_table(self):
        live = 'model = "x"\n\n[tui]\ntheme = "a"\n'
        out = self.assert_converged(live)
        self.assertTrue(out.startswith(TOP_LINES + "\n" + live))
        # 前置したキーが [tui] に入っていないこと。
        self.assertNotIn("approval_policy", tomllib.loads(out)["tui"])

    def test_only_prepends_missing_top_level_keys(self):
        live = (
            'approval_policy = "on-request"\nmodel = "x"\n\n'
            f'[sandbox_workspace_write]\nwritable_roots = ["{TASK_DATA}"]\n'
        )
        out = self.assert_converged(live)
        self.assertTrue(out.endswith(live))
        self.assertEqual(out.count("approval_policy"), 1)

    def test_overrides_conflicting_value(self):
        live = 'approval_policy = "never"\nmodel = "x"\n'
        cfg = tomllib.loads(self.assert_converged(live))
        self.assertEqual(cfg["model"], "x")

    def test_merges_into_existing_table(self):
        live = (
            "[sandbox_workspace_write]\n"
            "network_access = true\n"
            'writable_roots = ["/tmp/foo"]\n'
        )
        cfg = tomllib.loads(self.assert_converged(live))
        sww = cfg["sandbox_workspace_write"]
        self.assertTrue(sww["network_access"])
        self.assertEqual(sww["writable_roots"], ["/tmp/foo", TASK_DATA])

    def test_leaves_converged_file_byte_identical(self):
        live = (
            f'model = "x"\n{TOP_LINES}\n'
            f'[sandbox_workspace_write]\nwritable_roots = ["{TASK_DATA}"]\n'
        )
        self.assertEqual(render(live), live)

    def test_creates_file_from_empty(self):
        out = self.assert_converged("")
        self.assertEqual(
            out,
            f'{TOP_LINES}\n[sandbox_workspace_write]\nwritable_roots = ["{TASK_DATA}"]\n',
        )


if __name__ == "__main__":
    unittest.main()
