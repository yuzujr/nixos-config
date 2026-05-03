{ pkgs, ... }:
{
    programs.mpv = {
        enable = true;

        scripts = with pkgs.mpvScripts; [
            autoload
            modernz
            mpris
            quality-menu
            sponsorblock
            thumbfast
        ];

        config = {
            osc = false;
            osd-bar = false;
            ytdl-format = "bestvideo+bestaudio/best";
        };

        scriptOpts = {
            modernz = {
                icon_theme = "material";
            };
        };
    };
}
