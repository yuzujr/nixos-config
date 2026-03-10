{
  description = "GNU/GCC C++ dev shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            packages = [
              pkgs.gcc
              pkgs.cmake
              pkgs.xmake
              pkgs.ninja
              pkgs.pkg-config
              pkgs.gdb
            ];

            shellHook = ''
              export CC="${pkgs.gcc}/bin/gcc"
              export CXX="${pkgs.gcc}/bin/g++"
              echo "GNU C/C++ dev shell ready"
              echo "CC=$CC"
              echo "CXX=$CXX"
            '';
          };
        });
    };
}
