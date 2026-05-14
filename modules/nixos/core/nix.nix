{ ... }:
{
    nix.settings = {
        experimental-features = [
            "nix-command"
            "flakes"
        ];
        substituters = [
            "https://mirrors.ustc.edu.cn/nix-channels/store"
            "https://cache.nixos.org/"
        ];
        extra-substituters = [
            "https://noctalia.cachix.org"
        ];
        extra-trusted-public-keys = [
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
    };

    nix.channel.enable = false;

    nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
    };

    nix.optimise.automatic = true;
    nixpkgs.config.allowUnfree = true;
}
