{ pkgs, ... }:
{
    programs.mpv = {
        enable = true;

        scripts = with pkgs.mpvScripts; [
            autoload
            mpv-playlistmanager
            quality-menu
            sponsorblock
            thumbfast
            uosc
        ];

        config = {
            osc = false;
            osd-bar = false;
            ytdl-format = "bestvideo+bestaudio/best";
        };
    };

    home.packages = with pkgs; [
        yt-dlp
    ];
}
