{
    description = "Rust dev shell";

    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    outputs =
        { nixpkgs, ... }:
        let
            systems = [
                "x86_64-linux"
                "aarch64-linux"
            ];
            forAllSystems = nixpkgs.lib.genAttrs systems;
        in
        {
            devShells = forAllSystems (
                system:
                let
                    pkgs = import nixpkgs { inherit system; };
                in
                {
                    default = pkgs.mkShell {
                        packages = [
                            pkgs.rustc
                            pkgs.cargo
                            pkgs.clippy
                            pkgs.rustfmt
                            pkgs.rust-analyzer
                            pkgs.pkg-config
                            pkgs.lldb
                        ];

                        shellHook = ''
                            export RUST_SRC_PATH="${pkgs.rustPlatform.rustLibSrc}"
                            export CARGO_TERM_COLOR=always

                            echo
                            echo "rustc: $(rustc --version)"
                            echo "cargo: $(cargo --version)"
                        '';
                    };
                }
            );
        };
}
