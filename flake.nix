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

        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        secrets = {
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
            ];
            forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

            vars = import ./vars;

            mkHost =
                {
                    hostname,
                    system ? "x86_64-linux",
                }:
                let
                    specialArgs = {
                        inherit
                            home-manager
                            hostname
                            vars
                            sops-nix
                            secrets
                            ;
                        coomerPkg = coomer.packages.${system}.default;
                        drcomClientPkg = drcom-client-cpp.packages.${system}.default;
                        ani2xcursorPkg = ani2xcursor.packages.${system}.default;
                    };
                in
                nixpkgs.lib.nixosSystem {
                    inherit system specialArgs;
                    modules = [
                        ./hosts/laptop/default.nix
                    ];
                };

            mkDevShells = import ./devshells {
                inherit nixpkgs;
            };
        in
        {
            formatter = forAllSystems (system: (mkDevShells system).formatter);

            devShells = forAllSystems (system: (mkDevShells system).devShells);

            nixosConfigurations = {
                laptop = mkHost {
                    hostname = vars.hostname;
                };
            };
        };
}
