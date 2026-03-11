{ myvars, ... }:
{
  imports = [
    ./modules/shell-git.nix
    ./modules/dotfiles.nix
    ./modules/fcitx5.nix
  ];

  home = {
    inherit (myvars) username;
    stateVersion = "24.11";
  };
}
