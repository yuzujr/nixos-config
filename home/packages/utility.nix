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
