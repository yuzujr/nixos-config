{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
let
  secretsEnabled = config.modules.secrets.enable;
in
{
  programs.fish.enable = true;

  programs.ssh.extraConfig = lib.optionalString secretsEnabled ''
    Host github.com
      User git
      IdentityFile /etc/agenix/ssh-key-github

    Host gitee.com
      User git
      IdentityFile /etc/agenix/ssh-key-gitee

    Host server
      HostName 47.94.142.31
      User root
      IdentityFile /etc/agenix/ssh-key-server

    Host aur.archlinux.org
      User aur
      IdentityFile /etc/agenix/ssh-key-aur
  '';

  users.users.${myvars.username} = {
    isNormalUser = true;
    description = myvars.username;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
      "i2c"
    ];
  };

  # Disable Home Manager auto-activation at boot; run it manually when needed.
  systemd.services."home-manager-${myvars.username}".wantedBy = lib.mkForce [ ];
}
