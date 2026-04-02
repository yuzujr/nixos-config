{
    config,
    pkgs,
    vars,
    ...
}:
{
    services.dbus.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    services.orca.enable = false;
    services.speechd.enable = false;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    programs.niri.enable = true;
    services.desktopManager.plasma6.enable = true;
    programs.steam.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        elisa
        gwenview
        okular
        khelpcenter
        krdp
    ];

    environment.sessionVariables = {
        XDG_ICON_THEME = "Tela-circle";
        XDG_MENU_PREFIX = "plasma-";
        XMODIFIERS = "@im=fcitx";
        XCURSOR_THEME = "Bibata-Modern-Ice";
        XCURSOR_SIZE = "28";
        EDITOR = "nvim";
        NIXOS_OZONE_WL = "1";
        KWIN_DRM_DEVICES = "/dev/dri/by-path/pci-0000\\:01\\:00.0-card:/dev/dri/by-path/pci-0000\\:06\\:00.0-card";
    };

    fonts = {
        packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-color-emoji
            lxgw-wenkai
            maple-mono.NF-CN-unhinted
        ];

        fontconfig.defaultFonts = {
            monospace = [
                "Maple Mono NF CN"
                "Noto Color Emoji"
            ];
            sansSerif = [
                "Noto Sans CJK SC"
                "Noto Color Emoji"
            ];
            serif = [
                "Noto Serif CJK SC"
                "Noto Color Emoji"
            ];
            emoji = [ "Noto Color Emoji" ];
        };
    };

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

    services.greetd = {
        enable = true;
        settings = {
            terminal.vt = 1;

            initial_session = {
                command = "${pkgs.niri}/bin/niri-session";
                user = vars.username;
            };

            default_session = {
                command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions";
                user = "greeter";
            };
        };
    };

    xdg.portal = {
        enable = true;
        extraPortals = [
            pkgs.xdg-desktop-portal-gnome
        ];
    };

    # Keep Plasma installed, but disable KDE's crash handler entirely.
    systemd.services."drkonqi-coredump-processor@".enable = false;
    systemd.user.sockets."drkonqi-coredump-launcher".enable = false;
    systemd.user.services."drkonqi-coredump-launcher@".enable = false;
    systemd.user.services."drkonqi-coredump-pickup".enable = false;
    systemd.user.timers."drkonqi-coredump-cleanup".enable = false;
    systemd.user.services."drkonqi-sentry-postman".enable = false;
    systemd.user.paths."drkonqi-sentry-postman".enable = false;
    systemd.user.timers."drkonqi-sentry-postman".enable = false;

    services.logind.settings.Login = {
        HandlePowerKey = "ignore";
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        HandleLidSwitchDocked = "ignore";
    };

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
}
