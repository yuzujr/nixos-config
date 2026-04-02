{ pkgs, ... }:
{
    home.packages =
        with pkgs;
        let
            daily = [
                google-chrome
                kitty
                noctalia-shell
            ];

            communication = [
                qq
                wechat
            ];

            documentation = [
                libreoffice-fresh
                typora
                zathura
                zathuraPkgs.zathura_pdf_poppler
            ];

            media = [
                (obs-studio.override { browserSupport = false; })
                splayer
            ];

            gaming = [
                lutris
            ];

            secret = [
                seahorse
            ];
        in
        daily ++ communication ++ documentation ++ media ++ gaming ++ secret;
}
