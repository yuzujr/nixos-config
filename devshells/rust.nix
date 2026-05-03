{ pkgs, ... }:
pkgs.mkShell {
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

        echo
        echo "rustc: $(rustc --version)"
        echo "cargo: $(cargo --version)"
    '';
}
