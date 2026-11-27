import subprocess
import tomllib
import unittest
from pathlib import Path

TEMPLATE = (
    Path(__file__).parents[1] / "private_dot_codex" / "modify_private_config.toml"
)
HOME = Path.home()
TASK_DATA = str(HOME / ".local/share/task")
HERDR_SOCK = str(HOME / ".config/herdr/herdr.sock")
PROFILE = "herdr-worker"
TOP = {
    "approval_policy": "on-request",
    "approvals_reviewer": "auto_review",
    "default_permissions": PROFILE,
    "web_search": "live",
}
WANT_PROFILE = {
    "extends": ":workspace",
    "filesystem": {TASK_DATA: "write"},
    "network": {"enabled": True, "unix_sockets": {HERDR_SOCK: "allow"}},
}


def render(live: str) -> str:
    return subprocess.run(
        ["chezmoi", "execute-template", "--with-stdin", "--file", str(TEMPLATE)],
        input=live,
        capture_output=True,
        text=True,
        check=True,
    ).stdout


class CodexConfigModifyTests(unittest.TestCase):
    def assert_converged(self, live: str) -> dict:
        out = render(live)
        cfg = tomllib.loads(out)
        for key, value in TOP.items():
            self.assertEqual(cfg[key], value, key)
        # permission profile と旧来の sandbox 設定は併用できない
        # (sandbox_mode があると profile が無視される)。
        self.assertNotIn("sandbox_mode", cfg)
        self.assertNotIn("sandbox_workspace_write", cfg)
        self.assertIs(cfg["features"]["network_proxy"], True)
        self.assertEqual(cfg["permissions"][PROFILE], WANT_PROFILE)
        # 2 回目の apply では何も変えない (chezmoi status が汚れない)。
        self.assertEqual(render(out), out)
        return cfg

    def test_creates_file_from_empty(self):
        self.assert_converged("")

    def test_migrates_legacy_sandbox_settings(self):
        live = (
            'model = "x"\n'
            'sandbox_mode = "workspace-write"\n\n'
            "[tui]\n"
            'theme = "a"\n\n'
            "[sandbox_workspace_write]\n"
            f'writable_roots = ["{TASK_DATA}"]\n'
        )
        cfg = self.assert_converged(live)
        # 管理しないキーとテーブルは残す。
        self.assertEqual(cfg["model"], "x")
        self.assertEqual(cfg["tui"], {"theme": "a"})
        self.assertNotIn("approval_policy", cfg["tui"])

    def test_overrides_conflicting_value(self):
        live = 'approval_policy = "never"\nmodel = "x"\n'
        cfg = self.assert_converged(live)
        self.assertEqual(cfg["model"], "x")

    def test_keeps_other_features_and_profiles(self):
        live = (
            "[features]\n"
            "multi_agent = true\n\n"
            "[permissions.other]\n"
            'extends = ":read-only"\n'
        )
        cfg = self.assert_converged(live)
        self.assertIs(cfg["features"]["multi_agent"], True)
        self.assertEqual(cfg["permissions"]["other"], {"extends": ":read-only"})

    def test_replaces_drifted_profile(self):
        live = (
            f"[permissions.{PROFILE}]\n"
            'extends = ":workspace"\n\n'
            f"[permissions.{PROFILE}.network]\n"
            "enabled = true\n"
            'domains = { "example.com" = "allow" }\n'
        )
        # 管理する profile は丸ごと保証する。足された宛先は消える。
        self.assert_converged(live)

    def test_leaves_converged_file_byte_identical(self):
        out = render('model = "x"\n')
        live = "# Codex が書いた行の形を保つ\n" + out
        self.assertEqual(render(live), live)


if __name__ == "__main__":
    unittest.main()
