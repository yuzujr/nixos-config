{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alsa-firmware
    alsa-ucm-conf
    bluez
    brightnessctl
    btrfs-progs
    ddcutil
    efibootmgr
    exfatprogs
    glib
    inetutils
    parted
    pciutils
  ];
}
