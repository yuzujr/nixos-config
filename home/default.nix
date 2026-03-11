{ myvars, ... }:
{
  imports = [
    ./dotfiles/dotfiles.nix
  ];

  home = {
    inherit (myvars) username;
    stateVersion = "24.11";
  };
}
