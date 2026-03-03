{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  programs.fish.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = [
      # Required by drcom_client ELF binary.
      pkgs.stdenv.cc.cc.lib
    ];
  };
}
