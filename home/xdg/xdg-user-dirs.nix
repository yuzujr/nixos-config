{ ... }:
{
  # Keep XDG user directories on the standard English names even if the UI
  # message locale is set to Chinese.
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
