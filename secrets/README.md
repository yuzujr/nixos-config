# Secrets Management

This repository uses `agenix` for secret decryption at deployment time.

## Public/Private split

- Public repo default input: `mysecrets = path:./secrets/placeholder`.
- Real deployment input: override `mysecrets` with your private repository:

```bash
sudo nixos-rebuild switch \
  --override-input mysecrets git+ssh://git@github.com/<you>/nix-secrets.git?shallow=1 \
  --flake .#nixos
```

## Expected files in the private `nix-secrets` repo

- `ssh-key-github.age`
- `ssh-key-gitee.age`
- `ssh-key-server.age`
- `ssh-key-aur.age`
- `mihomo-config.yaml.age`
- `fcitx5-config.age`
- `fcitx5-profile.age`
- `fcitx5-private-classicui.conf.age`
- `fcitx5-private-notifications.conf.age`
- `fcitx5-private-rime.conf.age`

Use host SSH key `/etc/ssh/ssh_host_ed25519_key` + an offline recovery key for encryption recipients.
