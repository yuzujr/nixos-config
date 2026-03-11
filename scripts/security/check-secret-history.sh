#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

patterns=(
  'dotfiles/dot_ssh/keys/private_'
  'dotfiles/dot_config/mihomo/config.yaml'
  'dotfiles/dot_config/fcitx5/private_'
  'dotfiles/dot_config/fcitx5/conf/private_'
  'dotfiles/dot_config/drcom-client-cpp/drcom_jlu.conf'
  'dotfiles/dot_config/gold-price/gold-price-history.conf'
  'dotfiles/dot_config/nix/nix.conf'
)

echo "Checking Git history object names for removed secret paths..."
for p in "${patterns[@]}"; do
  if git rev-list --objects --all | rg -n "$p" >/dev/null; then
    echo "FOUND: $p"
    exit 1
  fi
  echo "OK: $p"
done

echo "History check passed."
