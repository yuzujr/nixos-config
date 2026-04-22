{ pkgs, ... }:
{
    home.packages =
        with pkgs;
        let
            desktopIntegration = [
                bluetui
                cliphist
                fuzzel
                gpu-screen-recorder
                libnotify
                mpvpaper
                networkmanagerapplet
                pavucontrol
                playerctl
                sunshine
                wev
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
                mpv
                satty
            ];

            partitioning = [
                gparted
            ];
        in
        desktopIntegration ++ gaming ++ mediaUtilities ++ partitioning;
}
