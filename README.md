# nixos-config

Single-host NixOS flake with:

- Home Manager integrated into `nixos-rebuild`
- Writable dotfiles via `mkOutOfStoreSymlink`
- agenix-based secret wiring
- Public-safe default (`nixos-public`) and private full target (`nixos`)
- Legacy `dotfiles/` content migrated into `home/linux/...` modules

## Targets

- `.#nixos-public`: public-evaluable fallback (secrets disabled)
- `.#nixos`: full desktop target (expects private secrets input override)

## Build

Public fallback:

```bash
sudo nixos-rebuild build --flake .#nixos-public
```

Full private target:

```bash
sudo nixos-rebuild build \
  --override-input mysecrets git+ssh://git@github.com/yuzujr/nix-secrets.git?shallow=1 \
  --flake .#nixos
```

Switch full private target:

```bash
sudo nixos-rebuild switch \
  --override-input mysecrets git+ssh://git@github.com/yuzujr/nix-secrets.git?shallow=1 \
  --flake .#nixos
```

## Secrets

See `secrets/README.md`.

## Security cleanup before publishing

1. Rotate all previously tracked secrets (SSH keys, mihomo token/config, FCITX private data).
2. Rewrite Git history to remove secret paths, then force-push.

Quick checks:

```bash
./scripts/security/check-secret-history.sh
```

Example `git filter-repo` path purge:

```bash
git filter-repo \
  --path dotfiles/dot_ssh/keys/private_aur --invert-paths \
  --path dotfiles/dot_ssh/keys/private_gitee --invert-paths \
  --path dotfiles/dot_ssh/keys/private_github --invert-paths \
  --path dotfiles/dot_ssh/keys/private_server --invert-paths \
  --path dotfiles/dot_config/mihomo/config.yaml --invert-paths \
  --path dotfiles/dot_config/fcitx5/private_config --invert-paths \
  --path dotfiles/dot_config/fcitx5/private_profile --invert-paths \
  --path dotfiles/dot_config/fcitx5/conf/private_classicui.conf --invert-paths \
  --path dotfiles/dot_config/fcitx5/conf/private_notifications.conf --invert-paths \
  --path dotfiles/dot_config/fcitx5/conf/private_rime.conf --invert-paths \
  --path dotfiles/dot_config/drcom-client-cpp/drcom_jlu.conf --invert-paths \
  --path dotfiles/dot_config/gold-price/gold-price-history.conf --invert-paths \
  --path dotfiles/dot_config/nix/nix.conf --invert-paths
```
