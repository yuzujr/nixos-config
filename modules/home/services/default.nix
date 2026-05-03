{ ... }:
{
    imports = [
        ./drcom-client.nix
        ./gold-price-history-daily.nix
        ./gold-price-watch.nix
        ./polkit-gnome-authentication-agent-1.nix
        ./sunshine.nix
        ./wl-clip-persist.nix
    ];

    services.mpris-proxy.enable = true;
}
