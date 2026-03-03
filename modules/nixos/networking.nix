{ ... }:

{
  networking.networkmanager = {
    enable = true;
    settings.connectivity.enabled = false;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  networking.firewall.enable = false;
}
