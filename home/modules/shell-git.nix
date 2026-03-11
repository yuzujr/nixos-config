{
  myvars,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = myvars.userfullname;
        email = myvars.useremail;
      };
      core = {
        pager = "delta";
        quotepath = false;
      };
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        dark = true;
      };
      merge.conflictStyle = "zdiff3";
      init.defaultBranch = "main";
    };
  };

  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../files/core/starship.toml);
  };
}
