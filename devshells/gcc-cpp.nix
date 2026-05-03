{ pkgs, ... }:
pkgs.mkShell {
    packages = [
        pkgs.cmake
        pkgs.xmake
        pkgs.ninja
        pkgs.pkg-config
        pkgs.gdb
        pkgs.clang-tools
    ];

    shellHook = ''
        export CC="${pkgs.gcc}/bin/gcc"
        export CXX="${pkgs.gcc}/bin/g++"
    '';
}
