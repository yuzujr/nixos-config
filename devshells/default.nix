{ nixpkgs }:
system:
let
    pkgs = nixpkgs.legacyPackages.${system};
    mkNixfmt =
        pkgs:
        pkgs.writeShellScriptBin "nixfmt" ''
            if [ "$#" -gt 0 ]; then
              exec ${pkgs.nixfmt}/bin/nixfmt --indent 4 "$@"
            fi

            root="''${PRJ_ROOT:-$PWD}"

            exec ${pkgs.fd}/bin/fd \
              --type f \
              --extension nix \
              --hidden \
              --exclude .git \
              --exclude .direnv \
              . "$root" \
              -X ${pkgs.nixfmt}/bin/nixfmt --indent 4
        '';
    linuxSystems = [
        "x86_64-linux"
    ];
    callShell = file: import file { inherit nixpkgs pkgs system; };
    linuxDevShells = {
        android-studio-env = callShell ./android-studio.nix;
        clang-cpp-env = callShell ./clang-cpp.nix;
        gcc-cpp-env = callShell ./gcc-cpp.nix;
        python-env = callShell ./python.nix;
        qt-env = callShell ./qt.nix;
        rust-env = callShell ./rust.nix;
    };
in
{
    formatter = mkNixfmt pkgs;

    devShells = {
        default = pkgs.mkShellNoCC {
            packages = [
                pkgs.nixd
                (mkNixfmt pkgs)
            ];
        };
    }
    // nixpkgs.lib.optionalAttrs (builtins.elem system linuxSystems) linuxDevShells;
}
