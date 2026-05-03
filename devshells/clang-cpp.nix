{ pkgs, ... }:
pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
    packages = [
        pkgs.cmake
        pkgs.xmake
        pkgs.ninja
        pkgs.pkg-config
        pkgs.lldb
        pkgs.clang-tools
    ];

    shellHook = ''
        export CC="${pkgs.clang}/bin/clang"
        export CXX="${pkgs.clang}/bin/clang++"
    '';
}
