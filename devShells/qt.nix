{ pkgs, ... }:
let
    qtEnv =
        with pkgs.qt6;
        env "qt6-env" [
            qtbase
            qtdeclarative
            qttools
            qtwayland
        ];
in
pkgs.mkShell {
    packages = [
        qtEnv
        pkgs.qtcreator
        pkgs.cmake
        pkgs.ninja
        pkgs.pkg-config
        pkgs.libglvnd
        pkgs.clang-tools
        pkgs.gdb
    ];

    shellHook = ''
        export CC="$(command -v cc)"
        export CXX="$(command -v c++)"
        export QT_CREATOR_SKIP_MAINTENANCE_TOOL_PROVIDER=ON
        echo
        echo "CC=$CC"
        echo "CXX=$CXX"
    '';
}
