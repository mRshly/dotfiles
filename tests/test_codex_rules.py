import json
import shlex
import shutil
import subprocess
import unittest
from pathlib import Path

RULES = Path(__file__).parents[1] / "private_dot_codex" / "rules" / "claude-parity.rules"


def decision(command: str) -> str | None:
    out = subprocess.run(
        ["codex", "execpolicy", "check", "--rules", str(RULES), "--", *shlex.split(command)],
        capture_output=True,
        text=True,
        check=True,
    ).stdout
    return json.loads(out).get("decision")


@unittest.skipUnless(shutil.which("codex"), "codex is not installed")
class ClaudeParityRulesTests(unittest.TestCase):
    def assert_decisions(self, expected: str | None, commands: list[str]):
        for command in commands:
            with self.subTest(command=command):
                self.assertEqual(decision(command), expected)

    def test_claude_deny_is_forbidden(self):
        self.assert_decisions(
            "forbidden",
            [
                "git push --force origin main",
                "git push -f",
                "git reset --hard HEAD",
                "git checkout .",
                "git clean -f -d",
                "git add .",
                "git add -A",
                "rm -rf build",
                "rm -r build",
                "chmod 777 x",
                "chmod -R 755 x",
                "chown -R me x",
                "killall Finder",
                "pkill node",
                "kill -9 1",
                "sudo ls",
                "su root",
                "open .",
                "osascript -e beep",
                "defaults write a b c",
                "ssh host",
                "scp a host:b",
                "rsync -a a b",
                "npm publish",
                "yarn publish",
                "pnpm publish",
                "terraform apply",
                "terraform destroy",
                "kubectl apply -f a.yaml",
                "kubectl delete pod x",
                "helm install a b",
                "helm upgrade a b",
                "docker push img",
                "podman push img",
            ],
        )

    def test_claude_ask_is_prompt(self):
        self.assert_decisions("prompt", ["npm install", "npm install lodash"])

    def test_everyday_commands_are_untouched(self):
        self.assert_decisions(
            None,
            [
                "git status",
                "git push origin main",
                "git push --force-with-lease origin main",
                "git add README.md",
                "rm foo.txt",
                "chmod +x a.sh",
                "kill 1",
                "npm test",
                "terraform plan",
            ],
        )


if __name__ == "__main__":
    unittest.main()
