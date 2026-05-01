{
    config,
    lib,
    pkgs,
    agenix,
    secrets,
    vars,
    ...
}:
let
    hasEncryptedFile = name: builtins.pathExists "${secrets}/${name}";
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
        agenix.nixosModules.default
    ];

    options.modules.secrets.enable = lib.mkEnableOption "agenix secret decryption and wiring";

    config = lib.mkIf config.modules.secrets.enable {
        environment.systemPackages = [
            agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];

        age.identityPaths = [
            "/etc/ssh/ssh_host_ed25519_key"
        ];

        age.secrets = {
            "ssh-key-github" = {
                file = "${secrets}/ssh-key-github.age";
            }
            // userSecret;

            "ssh-key-gitee" = {
                file = "${secrets}/ssh-key-gitee.age";
            }
            // userSecret;

            "ssh-key-server" = {
                file = "${secrets}/ssh-key-server.age";
            }
            // userSecret;

            "ssh-key-aur" = {
                file = "${secrets}/ssh-key-aur.age";
            }
            // userSecret;

            "mihomo.yaml" = {
                file = "${secrets}/mihomo.yaml.age";
            }
            // rootSecret;
        }
        // lib.optionalAttrs (hasEncryptedFile "drcom-jlu.conf.age") {
            "drcom-jlu.conf" = {
                file = "${secrets}/drcom-jlu.conf.age";
            }
            // userSecret;
        }
        // lib.optionalAttrs (hasEncryptedFile "gold-price-history.conf.age") {
            "gold-price-history.conf" = {
                file = "${secrets}/gold-price-history.conf.age";
            }
            // userSecret;
        }
        // lib.optionalAttrs (hasEncryptedFile "nix.conf.age") {
            "nix.conf" = {
                file = "${secrets}/nix.conf.age";
            }
            // userSecret;
        };
    };
}
