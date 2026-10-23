#!/bin/sh
# clone 直後に一度実行する、このリポジトリのローカル設定。
# 何度実行しても同じ状態になる。
set -eu

repo=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)

# commit hook は .githooks の素の git hook を使う。内容は各 hook のコメント参照。
# prek は素の git hook で扱えない検査にだけ使う方針で、現在その対象は無い。
# core.hooksPath はリポジトリのローカル設定で clone に含まれないため、ここで設定する。
git -C "$repo" config core.hooksPath .githooks
echo "core.hooksPath = $(git -C "$repo" config core.hooksPath)"
