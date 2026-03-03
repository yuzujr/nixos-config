{ ... }:

{
  programs.dconf.enable = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  hardware.steam-hardware.enable = true;
}
