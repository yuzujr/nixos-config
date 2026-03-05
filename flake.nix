{
  description = "yuzujr's NixOS configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dolphin-overlay = {
      url = "github:rumboon/dolphin-overlay";
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
      nur,
      neovim-nightly,
      dolphin-overlay,
      coomer,
      drcom-client-cpp,
      ani2xcursor,
      ...
    }:
    let
      system = "x86_64-linux";
      host = "nixos";
    in
    {
      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          coomerPkg = coomer.packages.${system}.default;
          drcomClientPkg = drcom-client-cpp.packages.${system}.default;
          ani2xcursorPkg = ani2xcursor.packages.${system}.default;
        };
        modules = [
          nur.modules.nixos.default
          {
            nixpkgs.overlays = [
              neovim-nightly.overlays.default
              dolphin-overlay.overlays.default
            ];
          }
          ./hosts/default/configuration.nix
        ];
      };
    };
}
