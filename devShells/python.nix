{ pkgs, ... }:
let
    python = pkgs.python312;
in
pkgs.mkShell {
    packages = [
        python
        pkgs.uv
    ];

    shellHook = ''
        export UV_PYTHON="${python}/bin/python"
        export UV_PYTHON_DOWNLOADS=never
        export PIP_DISABLE_PIP_VERSION_CHECK=1

        echo
        echo "Python: $(${python}/bin/python --version)"
    '';
}
