{
    config,
    lib,
    ...
}:
{
    programs.ssh.extraConfig = lib.optionalString config.modules.secrets.enable ''
        Host github.com
          User git
          IdentityFile ${config.sops.secrets."ssh/github".path}

        Host gitee.com
          User git
          IdentityFile ${config.sops.secrets."ssh/gitee".path}

        Host server
          HostName 47.94.142.31
          User root
          IdentityFile ${config.sops.secrets."ssh/server".path}

        Host aur.archlinux.org
          User aur
          IdentityFile ${config.sops.secrets."ssh/aur".path}
    '';
}
