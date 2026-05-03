# nixos-config

NixOS + Home Manager flake for my desktop setup (`niri` + Plasma 6), daily apps, and dotfiles.

## What this flake provides

- `nixosConfigurations.laptop`
  - Personal laptop setup.

## Repository layout

```text
.
├── devshells/               # Development shell definitions exposed by the root flake
├── flake.nix                # Inputs, outputs, host variants
├── hosts/laptop/            # Host entrypoint + generated hardware config
├── modules/home/            # Home Manager modules
├── modules/nixos/           # system modules
├── secrets/placeholder/     # Empty placeholder for private secrets input
├── vars/                    # username/hostname/repoRoot
└── dotfiles/                # User dotfiles linked by Home Manager
```

## Prerequisites

- NixOS with flakes enabled.
- `git`.

## Setup

Adjust `username`, `hostname` and `repoRoot` in `vars/default.nix`.

## Build and switch

```bash
sudo nixos-rebuild switch --flake .#laptop --override-input secrets path:/path/to/nixos-secrets
```

## Development shells

The root flake exposes these shell aliases:

```bash
nix develop .#gcc-cpp-env
nix develop .#clang-cpp-env
nix develop .#qt-env
nix develop .#python-env
nix develop .#android-studio-env
nix develop .#rust-env
```
