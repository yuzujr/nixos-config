{
    config,
    ...
}:
{
    programs.ssh.extraConfig = ''
        Host github.com
          User git
          IdentityFile ${config.sops.secrets."ssh/github".path}

        Host gitee.com
          User git
          IdentityFile ${config.sops.secrets."ssh/gitee".path}

        Host vm
          HostName 192.168.166.128
          User yuzujr
          IdentityFile ${config.sops.secrets."ssh/vm".path}

        Host aur.archlinux.org
          User aur
          IdentityFile ${config.sops.secrets."ssh/aur".path}
    '';
}
