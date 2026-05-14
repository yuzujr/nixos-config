{ ... }:
{
    imports = [
        ./drcom-client.nix
        ./gold-price-history-daily.nix
        ./gold-price-watch.nix
        ./sunshine.nix
        ./wl-clip-persist.nix
    ];

    services.mpris-proxy.enable = true;
}
