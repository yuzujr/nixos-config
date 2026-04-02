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

        environment.etc = {
            "agenix/ssh-key-github" = {
                source = config.age.secrets."ssh-key-github".path;
                mode = "0600";
                user = vars.username;
            };

            "agenix/ssh-key-gitee" = {
                source = config.age.secrets."ssh-key-gitee".path;
                mode = "0600";
                user = vars.username;
            };

            "agenix/ssh-key-server" = {
                source = config.age.secrets."ssh-key-server".path;
                mode = "0600";
                user = vars.username;
            };

            "agenix/ssh-key-aur" = {
                source = config.age.secrets."ssh-key-aur".path;
                mode = "0600";
                user = vars.username;
            };

            "agenix/mihomo-config.yaml" = {
                source = config.age.secrets."mihomo-config.yaml".path;
                mode = "0400";
                user = "root";
            };
        }
        // lib.optionalAttrs (lib.hasAttrByPath [ "drcom-jlu.conf" ] config.age.secrets) {
            "agenix/drcom-jlu.conf" = {
                source = config.age.secrets."drcom-jlu.conf".path;
                mode = "0400";
                user = vars.username;
            };
        }
        // lib.optionalAttrs (lib.hasAttrByPath [ "gold-price-history.conf" ] config.age.secrets) {
            "agenix/gold-price-history.conf" = {
                source = config.age.secrets."gold-price-history.conf".path;
                mode = "0400";
                user = vars.username;
            };
        }
        // lib.optionalAttrs (lib.hasAttrByPath [ "nix-user.conf" ] config.age.secrets) {
            "agenix/nix-user.conf" = {
                source = config.age.secrets."nix-user.conf".path;
                mode = "0400";
                user = vars.username;
            };
        };
    };
}
