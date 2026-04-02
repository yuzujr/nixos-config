{
    description = "Python dev shell with uv";

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
                    python = pkgs.python312;
                in
                {
                    default = pkgs.mkShell {
                        packages = [
                            python
                            pkgs.uv
                        ];

                        shellHook = ''
                            export UV_PYTHON="${python}/bin/python"
                            export UV_PYTHON_DOWNLOADS=never
                            export PIP_DISABLE_PIP_VERSION_CHECK=1

                            echo "Python dev shell ready"
                            echo "Python: $(${python}/bin/python --version)"
                            echo "Use: uv init | uv add | uv sync | uv run ..."
                        '';
                    };
                }
            );
        };
}
