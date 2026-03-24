{ myvars, ... }:
{
  imports = [
    ./dotfiles.nix
    ./systemd-user.nix
    ./userPackages.nix
  ];

  fonts.fontconfig.enable = false;

  home = {
    inherit (myvars) username;
    stateVersion = "24.11";
  };
}
