{
    description = "yuzujr's NixOS configuration";

    inputs = {
        nixpkgs = {
            url = "github:nixos/nixpkgs/nixos-unstable";
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        agenix = {
            url = "github:ryantm/agenix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        mysecrets = {
            url = "path:./secrets/placeholder";
            flake = false;
        };

        coomer = {
            url = "github:yuzujr/coomer";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        drcom-client-cpp = {
            url = "github:yuzujr/drcom-client-cpp";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        ani2xcursor = {
            url = "github:yuzujr/ani2xcursor";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs =
        {
            nixpkgs,
            home-manager,
            agenix,
            mysecrets,
            coomer,
            drcom-client-cpp,
            ani2xcursor,
            ...
        }:
        let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
            vars = import ./vars;
            nixfmtProject = pkgs.writeShellScriptBin "nixfmt" ''
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

            mkHost =
                {
                    hostname,
                    secretsEnabled,
                    mihomoEnabled,
                    userSystemdServicesEnabled,
                }:
                let
                    specialArgs = {
                        inherit
                            vars
                            agenix
                            mysecrets
                            userSystemdServicesEnabled
                            ;
                        coomerPkg = coomer.packages.${system}.default;
                        drcomClientPkg = drcom-client-cpp.packages.${system}.default;
                        ani2xcursorPkg = ani2xcursor.packages.${system}.default;
                    };
                in
                nixpkgs.lib.nixosSystem {
                    inherit system specialArgs;
                    modules = [
                        ./hosts/default/default.nix
                        ./secrets/nixos.nix

                        {
                            networking.hostName = hostname;
                            modules.secrets.enable = secretsEnabled;
                            modules.networking.mihomo.enable = mihomoEnabled;
                        }

                        home-manager.nixosModules.home-manager
                        {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;
                            home-manager.backupFileExtension = "home-manager.backup";
                            home-manager.extraSpecialArgs = specialArgs;
                            home-manager.users.${vars.username}.imports = [
                                ./home/default.nix
                            ];
                        }
                    ];
                };
        in
        {
            formatter.${system} = nixfmtProject;

            devShells.${system}.default = pkgs.mkShellNoCC {
                packages = [
                    pkgs.nixd
                    nixfmtProject
                ];
            };

            nixosConfigurations = {
                nixos = mkHost {
                    hostname = vars.hostname;
                    secretsEnabled = true;
                    mihomoEnabled = true;
                    userSystemdServicesEnabled = true;
                };

                nixos-public = mkHost {
                    hostname = vars.hostname;
                    secretsEnabled = false;
                    mihomoEnabled = false;
                    userSystemdServicesEnabled = false;
                };
            };
        };
}
