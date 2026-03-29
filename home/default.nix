{
  lib,
  myvars,
  userSystemdServicesEnabled,
  ...
}:
{
  imports = [
    ./packages
    ./git-config.nix
    ./links.nix
    ./xdg-autostart.nix
    ./xdg-desktop-entry-overrides.nix
    ./xdg-mime-apps.nix
  ]
  ++ lib.optionals userSystemdServicesEnabled [
    ./systemd-user
  ];

  fonts.fontconfig.enable = false;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home = {
    inherit (myvars) username;
    stateVersion = "24.11";
  };
}
