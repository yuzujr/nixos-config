{ inputs, system }:
final: prev: {
    niri = inputs.nixpkgs-master.legacyPackages.${system}.niri;
}
