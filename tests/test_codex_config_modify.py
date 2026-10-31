import subprocess
import tomllib
import unittest
from pathlib import Path

TEMPLATE = (
    Path(__file__).parents[1] / "private_dot_codex" / "modify_private_config.toml"
)
TASK_DATA = str(Path.home() / ".local/share/task")


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
        self.assertIn(TASK_DATA, cfg["sandbox_workspace_write"]["writable_roots"])
        # 2 回目の apply では何も変えない (chezmoi status が汚れない)。
        self.assertEqual(render(out), out)
        return out

    def test_appends_table_and_keeps_existing_text(self):
        live = 'model = "x"\n\n[tui]\ntheme = "a"\n'
        out = self.assert_converged(live)
        self.assertTrue(out.startswith(live))

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
        live = f'model = "x"\n\n[sandbox_workspace_write]\nwritable_roots = ["{TASK_DATA}"]\n'
        self.assertEqual(render(live), live)

    def test_creates_file_from_empty(self):
        out = self.assert_converged("")
        self.assertTrue(out.startswith("[sandbox_workspace_write]"))


if __name__ == "__main__":
    unittest.main()
