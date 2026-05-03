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
    users.mutableUsers = lib.mkIf config.modules.secrets.enable false;

    users.users.root = lib.mkIf config.modules.secrets.enable {
        hashedPasswordFile = config.sops.secrets."users/root/password-hash".path;
    };

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
    }
    // lib.optionalAttrs config.modules.secrets.enable {
        hashedPasswordFile = config.sops.secrets."users/${username}/password-hash".path;
    };

    # Disable Home Manager auto-activation at boot; run it manually when needed.
    # systemd.services."home-manager-${username}".wantedBy = lib.mkForce [ ];
}
