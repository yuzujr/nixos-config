{
  config,
  lib,
  pkgs,
  agenix,
  mysecrets,
  myvars,
  ...
}:
let
  cfg = config.modules.secrets;
  userSecret = {
    mode = "0400";
    owner = myvars.username;
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
      } // userSecret;

      "ssh-key-gitee" = {
        file = "${mysecrets}/ssh-key-gitee.age";
      } // userSecret;

      "ssh-key-server" = {
        file = "${mysecrets}/ssh-key-server.age";
      } // userSecret;

      "ssh-key-aur" = {
        file = "${mysecrets}/ssh-key-aur.age";
      } // userSecret;

      "mihomo-config.yaml" = {
        file = "${mysecrets}/mihomo-config.yaml.age";
      } // rootSecret;

      "fcitx5-config" = {
        file = "${mysecrets}/fcitx5-config.age";
      } // userSecret;

      "fcitx5-profile" = {
        file = "${mysecrets}/fcitx5-profile.age";
      } // userSecret;

      "fcitx5-classicui.conf" = {
        file = "${mysecrets}/fcitx5-classicui.conf.age";
      } // userSecret;

      "fcitx5-notifications.conf" = {
        file = "${mysecrets}/fcitx5-notifications.conf.age";
      } // userSecret;

      "fcitx5-rime.conf" = {
        file = "${mysecrets}/fcitx5-rime.conf.age";
      } // userSecret;
    };

    environment.etc = {
      "agenix/ssh-key-github" = {
        source = config.age.secrets."ssh-key-github".path;
        mode = "0600";
        user = myvars.username;
      };

      "agenix/ssh-key-gitee" = {
        source = config.age.secrets."ssh-key-gitee".path;
        mode = "0600";
        user = myvars.username;
      };

      "agenix/ssh-key-server" = {
        source = config.age.secrets."ssh-key-server".path;
        mode = "0600";
        user = myvars.username;
      };

      "agenix/ssh-key-aur" = {
        source = config.age.secrets."ssh-key-aur".path;
        mode = "0600";
        user = myvars.username;
      };

      "agenix/mihomo-config.yaml" = {
        source = config.age.secrets."mihomo-config.yaml".path;
        mode = "0400";
        user = "root";
      };

      "agenix/fcitx5-config" = {
        source = config.age.secrets."fcitx5-config".path;
        mode = "0400";
        user = myvars.username;
      };

      "agenix/fcitx5-profile" = {
        source = config.age.secrets."fcitx5-profile".path;
        mode = "0400";
        user = myvars.username;
      };

      "agenix/fcitx5-classicui.conf" = {
        source = config.age.secrets."fcitx5-classicui.conf".path;
        mode = "0400";
        user = myvars.username;
      };

      "agenix/fcitx5-notifications.conf" = {
        source = config.age.secrets."fcitx5-notifications.conf".path;
        mode = "0400";
        user = myvars.username;
      };

      "agenix/fcitx5-rime.conf" = {
        source = config.age.secrets."fcitx5-rime.conf".path;
        mode = "0400";
        user = myvars.username;
      };
    };
  };
}
