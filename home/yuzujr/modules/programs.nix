{ ... }:

{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      dark = true;
      navigate = true;
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "yuzujr";
        email = "15568103056@163.com";
      };
      core.quotepath = false;
      merge.conflictStyle = "zdiff3";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/keys/github";
      };

      "gitee.com" = {
        hostname = "gitee.com";
        user = "git";
        identityFile = "~/.ssh/keys/gitee";
      };

      "server" = {
        hostname = "47.94.142.31";
        user = "root";
        identityFile = "~/.ssh/keys/server";
      };

      "aur.archlinux.org" = {
        user = "aur";
        identityFile = "~/.ssh/keys/aur";
      };
    };
  };

  programs.fish.enable = true;
}
