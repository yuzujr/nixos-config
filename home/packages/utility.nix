{ pkgs, ... }:
{
    home.packages =
        with pkgs;
        let
            desktopIntegration = [
                bluetui
                cliphist
                fuzzel
                file
                gpu-screen-recorder
                gparted
                libnotify
                networkmanagerapplet
                pavucontrol
                playerctl
                sunshine
                unrar
                wev
                wine-staging
                winetricks
                wl-clipboard
                wl-clip-persist
                xwayland-satellite
            ];

            gaming = [
                gamescope
                gamemode
                mangohud
            ];

            mediaUtilities = [
                ffmpeg
                feh
                mpv-unwrapped
            ];

        in
        desktopIntegration ++ gaming ++ mediaUtilities;
}
