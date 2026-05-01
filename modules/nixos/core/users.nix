{
    config,
    lib,
    pkgs,
    vars,
    ...
}:
let
    inherit (vars) username;
in
{
    programs.fish.enable = true;

    programs.ssh.extraConfig = lib.optionalString config.modules.secrets.enable ''
        Host github.com
          User git
          IdentityFile ${config.age.secrets."ssh-key-github".path}

        Host gitee.com
          User git
          IdentityFile ${config.age.secrets."ssh-key-gitee".path}

        Host server
          HostName 47.94.142.31
          User root
          IdentityFile ${config.age.secrets."ssh-key-server".path}

        Host aur.archlinux.org
          User aur
          IdentityFile ${config.age.secrets."ssh-key-aur".path}
    '';

    users.users.${username} = {
        isNormalUser = true;
        description = username;
        shell = pkgs.fish;
        extraGroups = [
            "wheel"
            "networkmanager"
            "audio"
            "video"
            "input"
            "i2c"
        ];
    };

    # Disable Home Manager auto-activation at boot; run it manually when needed.
    systemd.services."home-manager-${username}".wantedBy = lib.mkForce [ ];
}
