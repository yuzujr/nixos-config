{
  description = "yuzujr's modular NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    coomer = {
      url = "git+ssh://git@github.com/yuzujr/coomer";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    drcom-client-cpp = {
      url = "git+ssh://git@github.com/yuzujr/drcom-client-cpp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nur, neovim-nightly, coomer, drcom-client-cpp, ... }:
    let
      system = "x86_64-linux";
      host = "nixos";
    in {
      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          coomerPkg      = coomer.packages.${system}.default;
          drcomClientPkg = drcom-client-cpp.packages.${system}.default;
        };
        modules = [
          nur.modules.nixos.default
          ({ ... }: {
            nixpkgs.overlays = [ neovim-nightly.overlays.default ];
          })
          ./hosts/default/configuration.nix
        ];
      };
    };
}
