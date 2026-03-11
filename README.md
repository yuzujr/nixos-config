# NixOS Config

Single-host NixOS + Home Manager + agenix.

This repo is intentionally kept simple for public sharing:
- one flake
- one host (`hosts/default`)
- one Home Manager entry (`home/default.nix`)
- one README (this file)

## Main targets

- `.#nixos-public`: public-evaluable build (no private secrets required)
- `.#nixos`: full private build (expects private `mysecrets` override)

## Repo layout

- `flake.nix`: entrypoint and host outputs
- `hosts/default/`: host hardware + host-level imports
- `modules/`: NixOS modules (`base`, `desktop`, `hardware`, `packages`)
- `home/default.nix`: Home Manager entry for user config
- `home/dotfiles/dotfiles.nix`: Home Manager symlink wiring
- `home/dotfiles/`: plain-text dotfiles and app configs
- `secrets/nixos.nix`: agenix decryption + `/etc/agenix/*` wiring
- `secrets/placeholder/`: public-safe fallback input for `mysecrets`

## Build and switch

Public build:

```bash
sudo nixos-rebuild build --flake .#nixos-public
```

Private build:

```bash
sudo nixos-rebuild build \
  --override-input mysecrets git+ssh://git@github.com/<you>/nix-secrets.git?shallow=1 \
  --flake .#nixos
```

Private switch:

```bash
sudo nixos-rebuild switch \
  --override-input mysecrets git+ssh://git@github.com/<you>/nix-secrets.git?shallow=1 \
  --flake .#nixos
```

## Update workflow

1. Update flake inputs:

```bash
nix flake update
```

2. Validate:

```bash
nix flake check
sudo nixos-rebuild build --flake .#nixos-public
sudo nixos-rebuild build \
  --override-input mysecrets git+ssh://git@github.com/<you>/nix-secrets.git?shallow=1 \
  --flake .#nixos
```

3. Switch when ready.

## Add a new public dotfile

1. Put the real file under this repo, usually in `home/dotfiles/...`.
2. Add a symlink mapping in `home/dotfiles/dotfiles.nix` using `mkOutOfStoreSymlink`.
3. Rebuild and confirm with `readlink` that `~/.config/...` points to your repo file.
4. If the app generates runtime/cache files in that directory, add ignore rules (local `.gitignore` preferred).

## Add a new private secret file

1. In your private `nix-secrets` repo, add `./<name>.age`.publicKeys entry to `secrets.nix`.
2. Encrypt content:

```bash
EDITOR='cp /path/to/plaintext' agenix -e ./<name>.age
```

3. Wire it in this repo:
- add `age.secrets.<name>` in `secrets/nixos.nix`
- add `/etc/agenix/<name>` mapping in `environment.etc`
- reference `/etc/agenix/<name>` from the consumer (service or Home Manager link)

4. Rebuild `.#nixos` with `--override-input mysecrets ...`.

## Public repo safety checklist

- Never commit plaintext credentials/tokens/keys.
- Keep only encrypted `.age` files in the private repo.
- Before pushing, run:

```bash
git status
nix flake check
sudo nixos-rebuild build --flake .#nixos-public
```
