# nixos-config

NixOS + Home Manager flake for my desktop setup (`niri` + Plasma 6), daily apps, and dotfiles.

## What this flake provides

- `nixosConfigurations.nixos`
  - Personal full setup (private profile).
- `nixosConfigurations.nixos-public`
  - Public-safe setup intended for sharing/reuse.

## Repository layout

```text
.
├── flake.nix                # Inputs, outputs, host variants
├── hosts/default/           # Host entrypoint + generated hardware config
├── modules/                 # System modules (nix/users/locale/desktop/features/hardware/packages)
├── home/                    # Home Manager entrypoint + dotfiles wiring
├── secrets/                 # agenix module + placeholder secrets directory
├── vars/default.nix         # username/hostname/repoRoot
└── dev/                     # Standalone dev shells (gcc-cpp-env, clang-cpp-env, qt-env, python-env, android-studio-env)
```

## Prerequisites

- NixOS with flakes enabled.
- `git`.

## Setup

Adjust `username`, `hostname` and `repoRoot` in `vars/default.nix`.

## Build and switch

### Public profile

```bash
sudo nixos-rebuild switch --flake .#nixos-public
```

### Personal full profile

```bash
sudo nixos-rebuild switch --flake .#nixos
```

## Private profile note

`.#nixos` is my personal profile and depends on private inputs/config.
For most users, start with `.#nixos-public`.

## Development shells

- GNU C/C++ environment:

- Clang/LLVM C/C++ environment:

- Qt environment (Qt Creator + Qt6 toolchain):

- Python environment (`uv` + Python 3.12):

- Android Studio environment:
