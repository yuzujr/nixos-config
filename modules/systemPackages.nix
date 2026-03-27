{
  lib,
  pkgs,
  ...
}:
let
  hardwarePackages = with pkgs; [
    alsa-firmware
    alsa-ucm-conf
    bluez
    brightnessctl
    ddcutil
    glib
    pciutils
  ];

  storagePackages = with pkgs; [
    btrfs-progs
    efibootmgr
    exfatprogs
    parted
  ];

  networkPackages = with pkgs; [
    inetutils
    openssh
  ];

  recoveryPackages = with pkgs; [
    curl
    fd
    git
    jq
    nh
    nix-tree
    ripgrep
    tree
    unzip
    vim
    wget
    zip
  ];
in
{
  environment.systemPackages = lib.concatLists [
    hardwarePackages
    storagePackages
    networkPackages
    recoveryPackages
  ];
}
