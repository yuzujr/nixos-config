#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

sudo nixos-rebuild switch \
  --override-input mysecrets git+ssh://git@github.com/yuzujr/nix-secrets.git?shallow=1 \
  --flake "$repo_root#nixos"
