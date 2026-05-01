{ pkgs, ... }:
{
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
}