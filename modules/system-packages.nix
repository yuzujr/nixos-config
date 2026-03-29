{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    let
      firmware = [
        alsa-firmware
        alsa-ucm-conf
        bluez
        glib
      ];

      hardware = [
        brightnessctl
        dconf
        ddcutil
        pciutils
      ];

      storage = [
        btrfs-progs
        efibootmgr
        exfatprogs
        parted
      ];

      network = [
        curl
        inetutils
        openssh
        wget
      ];

      nix = [
        nh
        nix-tree
      ];

      utility = [
        git
        jq
        tree
        unzip
        vim
        zip
      ];
    in
    firmware ++ hardware ++ storage ++ network ++ nix ++ utility;
}
