{
  description = "Qt dev shell for Qt Creator on NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          qtEnv = with pkgs.qt6; env "qt6-env" [
            qtbase
            qtdeclarative
            qttools
            qtwayland
          ];
        in {
          default = pkgs.mkShell {
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
              echo "CC=$CC"
              echo "CXX=$CXX"
            '';
          };
        });
    };
}
