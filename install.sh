#!/usr/bin/env bash
# Installs the hyperplan skill for every project (user scope).
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)/.claude/skills/hyperplan"
dest="${HOME}/.claude/skills/hyperplan"
mkdir -p "$(dirname "$dest")"
rm -rf "$dest"
cp -r "$src" "$dest"
echo "Installed hyperplan to $dest"
