{
  lib,
  pkgs,
  myvars,
  ...
}:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
  };

  nix.channel.enable = false;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.optimise.automatic = true;
  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  programs.ssh.extraConfig = ''
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

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_MESSAGES = "zh_CN.UTF-8";
  };
}
