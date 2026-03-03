{ ... }:

{
  environment.sessionVariables = {
    NO_AT_BRIDGE = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XDG_ICON_THEME = "Tela-circle";
    XMODIFIERS = "@im=fcitx";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "28";
  };

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
}
