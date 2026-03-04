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

  # Allow root (sudo nixos-rebuild) to fetch private repos via SSH using
  # yuzujr's GitHub key.  /etc/ssh/ssh_config is used as fallback for root
  # since root has no ~/.ssh/config of its own.
  programs.ssh.extraConfig = ''
    Host github.com
      User git
      IdentityFile /home/yuzujr/.ssh/keys/github
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
