{ config, pkgs, ... }:

{
  # ==========================================
  # Core System Services
  # ==========================================
  services.dbus.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "Polkit GNOME Authentication Agent";
    partOf = [ "niri.service" ];
    after = [ "niri.service" ];
    bindsTo = [ "niri.service" ];
    wantedBy = [ "niri.service" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # ==========================================
  # Networking & Proxies
  # ==========================================
  networking.networkmanager = {
    enable = true;
    settings.connectivity.enabled = false;
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.firewall.enable = false;

  services.openssh.enable = true;
  
  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
    configFile = ../../dotfiles/dot_config/mihomo/config.yaml;
  };

  # ==========================================
  # Audio (Pipewire)
  # ==========================================
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # ==========================================
  # Desktop Environment & Display Manager
  # ==========================================
  programs.niri.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;

      initial_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "yuzujr";
      };

      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions";
        user = "greeter";
      };
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  xdg.mime.defaultApplications = {
  "inode/directory" = "org.kde.dolphin.desktop";
  };

  # ==========================================
  # Environment Variables
  # ==========================================
  environment.sessionVariables = {
    NO_AT_BRIDGE = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XDG_ICON_THEME = "Tela-circle";
    XDG_MENU_PREFIX = "plasma-";
    XMODIFIERS = "@im=fcitx";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "28";
    EDITOR = "nvim";
  };

  # ==========================================
  # Fonts
  # ==========================================
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      lxgw-wenkai
      maple-mono.NF-CN-unhinted
    ];

    fontconfig.defaultFonts = {
      monospace = [ "Maple Mono NF CN" "Noto Color Emoji" ];
      sansSerif = [ "Noto Sans CJK SC" "Noto Color Emoji" ];
      serif = [ "Noto Serif CJK SC" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # ==========================================
  # Input Methods
  # ==========================================
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mellow-themes
      (fcitx5-rime.override {
        rimeDataPkgs = [ pkgs.rime-ice ];
      })
      qt6Packages.fcitx5-configtool
    ];
  };
}
