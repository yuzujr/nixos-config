{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    alsa-firmware
    alsa-ucm-conf
    bluez
    btrfs-progs
    efibootmgr
    exfatprogs
  ];
}
