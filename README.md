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

1. Clone this repo to the same path used by `repoRoot` in `vars/default.nix`.
2. If your clone path differs, update `repoRoot` in `vars/default.nix`.
3. Optionally adjust `username`, `userfullname`, `useremail`, and `hostname` in `vars/default.nix`.

`repoRoot` matters because Home Manager uses out-of-store symlinks to files in this repository.

## Build and switch

### Public profile

```bash
sudo nixos-rebuild switch --flake .#nixos-public
```

### Personal full profile

```bash
sudo nixos-rebuild switch --flake .#nixos
```

You can also build without switching:

```bash
nix build .#nixosConfigurations.nixos.config.system.build.toplevel
nix build .#nixosConfigurations.nixos-public.config.system.build.toplevel
```

## Private profile note

`.#nixos` is my personal profile and depends on private inputs/config.
For most users, start with `.#nixos-public`.

## Development shells

- GNU C/C++ environment:

```bash
nix develop ./dev/gcc-cpp-env
```

- Clang/LLVM C/C++ environment:

```bash
nix develop ./dev/clang-cpp-env
```

- Qt environment (Qt Creator + Qt6 toolchain):

```bash
nix develop ./dev/qt-env
```

- Python environment (`uv` + Python 3.12):

```bash
nix develop ./dev/python-env
```

How to use it:

```bash
# new project
uv init

# existing project with pyproject.toml
uv sync

# add dependencies
uv add requests
uv add --dev ruff pyright pytest

# run commands inside the project environment
uv run python main.py
uv run ruff check .
uv run pyright
```

You do not need to create or activate a virtualenv manually. Run the shell from each project's root, then use `uv` there so every project keeps its own separate dependencies.

If you want automatic activation with `direnv`, add this to the project's `.envrc`:

```bash
use flake /home/yuzujr/nixos-config/dev/python-env
```

- Android Studio environment:

```bash
nix develop ./dev/android-studio-env
```

## Updating inputs

```bash
nix flake update
```
