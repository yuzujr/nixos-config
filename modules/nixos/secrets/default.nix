{
    pkgs,
    sops-nix,
    secrets,
    vars,
    ...
}:
let
    mkSecret =
        file: key: attrs:
        {
            sopsFile = "${secrets}/secrets/${file}";
            inherit key;
        }
        // attrs;

    userSecret = {
        mode = "0400";
        owner = vars.username;
    };
    rootSecret = {
        mode = "0400";
        owner = "root";
    };
in
{
    imports = [
        sops-nix.nixosModules.sops
    ];

    environment.systemPackages = [
        pkgs.sops
    ];

    sops = {
        age.keyFile = "/home/${vars.username}/.config/sops/age/keys.txt";

        secrets = {
            "ssh/github" = mkSecret "ssh.yaml" "github" userSecret;
            "ssh/gitee" = mkSecret "ssh.yaml" "gitee" userSecret;
            "ssh/server" = mkSecret "ssh.yaml" "server" userSecret;
            "ssh/aur" = mkSecret "ssh.yaml" "aur" userSecret;

            "network/mihomo" = mkSecret "network.yaml" "mihomo" rootSecret;
            "network/drcom-jlu" = mkSecret "network.yaml" "drcom-jlu" userSecret;

            "apps/gold-price-history" = mkSecret "apps.yaml" "gold-price-history" userSecret;

            "nix/user-conf" = mkSecret "nix.yaml" "user-conf" userSecret;

            "users/${vars.username}/password-hash" = mkSecret "users.yaml" "${vars.username}-password-hash" (
                rootSecret
                // {
                    neededForUsers = true;
                }
            );

            "users/root/password-hash" = mkSecret "users.yaml" "root-password-hash" (
                rootSecret
                // {
                    neededForUsers = true;
                }
            );
        };
    };
}
