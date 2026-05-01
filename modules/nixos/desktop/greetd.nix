{ config, pkgs, vars, ... }:
{
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
}