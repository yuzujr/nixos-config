{
  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user = {
        email = "15568103056@163.com";
        name = "yuzujr";
      };

      core.quotepath = false;
      merge.conflictStyle = "zdiff3";
      init.defaultBranch = "main";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      dark = true;
    };
  };
}
