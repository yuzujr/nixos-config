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

    # Public-safe default. Override this input for real deployments:assets/
    # --override-input mysecrets git+ssh://git@github.com/<you>/nix-secrets.git?shallow=1
    mysecrets = {
      url = "path:./secrets/placeholder";
      flake = false;
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
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

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      agenix,
      mysecrets,
      neovim-nightly,
      coomer,
      drcom-client-cpp,
      ani2xcursor,
      noctalia,
      ...
    }:
    let
      system = "x86_64-linux";
      myvars = import ./vars;

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
              myvars
              agenix
              mysecrets
              userSystemdServicesEnabled
              ;
            coomerPkg = coomer.packages.${system}.default;
            drcomClientPkg = drcom-client-cpp.packages.${system}.default;
            ani2xcursorPkg = ani2xcursor.packages.${system}.default;
            noctaliaPkg = noctalia.packages.${system}.default;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            {
              nixpkgs.overlays = [
                neovim-nightly.overlays.default
              ];
            }

            ./hosts/default/default.nix
            ./secrets/nixos.nix

            {
              networking.hostName = hostname;
              modules.secrets.enable = secretsEnabled;
              modules.features.mihomo.enable = mihomoEnabled;
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "home-manager.backup";
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${myvars.username}.imports = [
                ./home/default.nix
              ];
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        nixos = mkHost {
          hostname = myvars.hostname;
          secretsEnabled = true;
          mihomoEnabled = true;
          userSystemdServicesEnabled = true;
        };

        nixos-public = mkHost {
          hostname = myvars.hostname;
          secretsEnabled = false;
          mihomoEnabled = false;
          userSystemdServicesEnabled = false;
        };
      };
    };
}
