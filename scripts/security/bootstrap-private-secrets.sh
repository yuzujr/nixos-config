#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <private-secrets-repo-path>" >&2
  exit 1
fi

repo_dir="$1"
mkdir -p "$repo_dir"

if [[ ! -d "$repo_dir/.git" ]]; then
  git -C "$repo_dir" init -b main
fi

cat > "$repo_dir/.gitignore" <<'GITIGNORE'
# Never store decrypted secret material
*.tmp
*.plain
*.decrypted
GITIGNORE

cat > "$repo_dir/secrets.nix" <<'SECRETSNIX'
# This file is only used by agenix CLI for encryption recipients.
# Replace these placeholders before encrypting real secrets.
let
  host_nixos = "ssh-ed25519 REPLACE_WITH_/etc/ssh/ssh_host_ed25519_key.pub root@nixos";
  recovery = "ssh-ed25519 REPLACE_WITH_OFFLINE_RECOVERY_KEY recovery@offline";

  recipients = [
    host_nixos
    recovery
  ];
in
{
  "./ssh-key-github.age".publicKeys = recipients;
  "./ssh-key-gitee.age".publicKeys = recipients;
  "./ssh-key-server.age".publicKeys = recipients;
  "./ssh-key-aur.age".publicKeys = recipients;

  "./mihomo-config.yaml.age".publicKeys = recipients;

  "./fcitx5-config.age".publicKeys = recipients;
  "./fcitx5-profile.age".publicKeys = recipients;
  "./fcitx5-classicui.conf.age".publicKeys = recipients;
  "./fcitx5-notifications.conf.age".publicKeys = recipients;
  "./fcitx5-rime.conf.age".publicKeys = recipients;
}
SECRETSNIX

cat > "$repo_dir/README.md" <<'README'
# nix-secrets

Private encrypted secret repo for `nixos-config`.

## 1. Set recipients

Edit `secrets.nix` and replace:
- `host_nixos` with output of: `cat /etc/ssh/ssh_host_ed25519_key.pub`
- `recovery` with your offline recovery public key

## 2. Encrypt secrets (examples)

```bash
nix shell github:ryantm/agenix#agenix

# Interactive edit
sudo agenix -e ./ssh-key-github.age -i /etc/ssh/ssh_host_ed25519_key

# Encrypt existing file to .age
cat ./plain/ssh-key-github | sudo agenix -e ./ssh-key-github.age -i /etc/ssh/ssh_host_ed25519_key
```

Repeat for all required files:
- ssh-key-github.age
- ssh-key-gitee.age
- ssh-key-server.age
- ssh-key-aur.age
- mihomo-config.yaml.age
- fcitx5-config.age
- fcitx5-profile.age
- fcitx5-classicui.conf.age
- fcitx5-notifications.conf.age
- fcitx5-rime.conf.age

## 3. Use with nixos-config

```bash
sudo nixos-rebuild switch \
  --override-input mysecrets git+ssh://git@github.com/yuzujr/nix-secrets.git?shallow=1 \
  --flake /home/yuzujr/nixos-config#nixos
```
README

chmod +x "$repo_dir" >/dev/null 2>&1 || true

echo "Initialized private secrets repo scaffold at: $repo_dir"
echo "Next: fill recipients in $repo_dir/secrets.nix, encrypt files, commit, and push."
