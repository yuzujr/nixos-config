{
    config,
    lib,
    pkgs,
    agenix,
    mysecrets,
    vars,
    ...
}:
let
    cfg = config.modules.secrets;
    hasEncryptedFile = name: builtins.pathExists "${mysecrets}/${name}";
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

    config = lib.mkIf cfg.enable {
        environment.systemPackages = [
            agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];

        age.identityPaths = [
            "/etc/ssh/ssh_host_ed25519_key"
        ];

        age.secrets = {
            "ssh-key-github" = {
                file = "${mysecrets}/ssh-key-github.age";
            }
            // userSecret;

            "ssh-key-gitee" = {
                file = "${mysecrets}/ssh-key-gitee.age";
            }
            // userSecret;

            "ssh-key-server" = {
                file = "${mysecrets}/ssh-key-server.age";
            }
            // userSecret;

            "ssh-key-aur" = {
                file = "${mysecrets}/ssh-key-aur.age";
            }
            // userSecret;

            "mihomo-config.yaml" = {
                file = "${mysecrets}/mihomo-config.yaml.age";
            }
            // rootSecret;
        }
        // lib.optionalAttrs (hasEncryptedFile "drcom-jlu.conf.age") {
            "drcom-jlu.conf" = {
                file = "${mysecrets}/drcom-jlu.conf.age";
            }
            // userSecret;
        }
        // lib.optionalAttrs (hasEncryptedFile "gold-price-history.conf.age") {
            "gold-price-history.conf" = {
                file = "${mysecrets}/gold-price-history.conf.age";
            }
            // userSecret;
        }
        // lib.optionalAttrs (hasEncryptedFile "nix-user.conf.age") {
            "nix-user.conf" = {
                file = "${mysecrets}/nix-user.conf.age";
            }
            // userSecret;
        };
    };
}
