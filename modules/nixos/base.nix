{ pkgs, ... }:

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
      IdentityFile /home/yuzujr/.ssh/keys/github

    Host gitee.com
      User git
      IdentityFile ~/.ssh/keys/gitee

    Host server
      HostName 47.94.142.31
      User root
      IdentityFile ~/.ssh/keys/server

    Host aur.archlinux.org
      User aur
      IdentityFile ~/.ssh/keys/aur
  '';

  users.users.yuzujr = {
    isNormalUser = true;
    description = "yuzujr";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
    ];
  };

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
