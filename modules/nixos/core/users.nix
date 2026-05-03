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
    users.mutableUsers = false;

    users.users.root = {
        hashedPasswordFile = config.sops.secrets."users/root/password-hash".path;
    };

    users.users.${username} = {
        isNormalUser = true;
        description = username;
        shell = pkgs.fish;
        hashedPasswordFile = config.sops.secrets."users/${username}/password-hash".path;
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
