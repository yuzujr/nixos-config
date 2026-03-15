{ myvars, ... }:
{
  imports = [
    ./dotfiles/dotfiles.nix
    ./systemd-user.nix
  ];

  fonts.fontconfig.enable = false;

  home = {
    inherit (myvars) username;
    stateVersion = "24.11";
  };
}
