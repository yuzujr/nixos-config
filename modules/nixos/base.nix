{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.optimise.automatic = true;

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  # Declarative SSH config — replaces ~/.ssh/config entirely.
  # Absolute path for github.com so root (sudo nixos-rebuild) can also authenticate.
  # ~ in IdentityFile expands to the connecting user's home for all other hosts.
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

  programs.ssh.knownHosts = {
    "github.com" = {
      hostNames = [ "github.com" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };
    "gitee.com" = {
      hostNames = [ "gitee.com" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEKxHSJ7084RmkJ4YdEi5tngynE8aZe2uEoVVsB/OvYN";
    };
    "aur.archlinux.org" = {
      hostNames = [ "aur.archlinux.org" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuBKrPzbawxA/k2g6NcyV5jmqwJ2s+zpgZGZ7tpLIcN";
    };
  };

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
