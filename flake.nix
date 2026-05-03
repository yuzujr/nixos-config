{
    description = "yuzujr's NixOS configuration";

    inputs = {
        nixpkgs = {
            url = "github:nixos/nixpkgs/nixos-unstable";
        };

        nixpkgs-master = {
            url = "github:nixos/nixpkgs/master";
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        secrets = {
            url = "path:./modules/secrets/placeholder";
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
        inputs@{
            self,
            nixpkgs,
            home-manager,
            sops-nix,
            secrets,
            coomer,
            drcom-client-cpp,
            ani2xcursor,
            ...
        }:
        let
            supportedSystems = [
                "x86_64-linux"
                "aarch64-linux"
                "x86_64-darwin"
                "aarch64-darwin"
            ];
            forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

            vars = import ./modules/vars;

            mkNixfmt =
                pkgs:
                pkgs.writeShellScriptBin "nixfmt" ''
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
                    system ? "x86_64-linux",
                }:
                let
                    pkgs = nixpkgs.legacyPackages.${system};
                    specialArgs = {
                        inherit
                            vars
                            sops-nix
                            secrets
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
                        ./hosts/nixos/default.nix
                        ./modules/secrets/nixos.nix

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
                                ./modules/home
                            ];
                        }
                    ];
                };
        in
        {
            formatter = forAllSystems (system: mkNixfmt nixpkgs.legacyPackages.${system});

            devShells = forAllSystems (
                system:
                let
                    pkgs = nixpkgs.legacyPackages.${system};
                in
                {
                    default = pkgs.mkShellNoCC {
                        packages = [
                            pkgs.nixd
                            (mkNixfmt pkgs)
                        ];
                    };
                }
            );

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
