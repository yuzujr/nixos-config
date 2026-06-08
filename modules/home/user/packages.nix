{
    pkgs,
    coomerPkg,
    drcomClientPkg,
    ani2xcursorPkg,
    noctaliaPkg,
    ...
}:
let
    custom = [
        coomerPkg
        drcomClientPkg
        ani2xcursorPkg
        noctaliaPkg
    ];

    development = with pkgs; [
        binutils
        cc-switch
        codex
        antigravity-cli
        claude-code
        gcc
        gnumake
        neovim
        nodejs
        python3
        vscode
    ];

    desktop = with pkgs; [
        bluetui
        feh
        fuzzel
        google-chrome
        gparted
        kitty
        libnotify
        libreoffice-fresh
        networkmanagerapplet
        pavucontrol
        qq
        seahorse
        splayer
        sunshine
        typora
        wechat
        xwayland-satellite
        zathura
        zathuraPkgs.zathura_pdf_poppler
    ];

    media = with pkgs; [
        ffmpeg
        gpu-screen-recorder
        (obs-studio.override { browserSupport = false; })
        playerctl
    ];

    theming = with pkgs; [
        adw-gtk3
        bibata-cursors
        rose-pine-cursor
        kdePackages.qt6ct
        nwg-look
        tela-circle-icon-theme
    ];

    terminal = with pkgs; [
        btop
        cmatrix
        csvlens
        duf
        dust
        eza
        fastfetch
        fd
        fzf
        nyancat
        ripgrep
        starship
        yazi
        zoxide
    ];

    utilities = with pkgs; [
        appimage-run
        cliphist
        file
        unrar
        wev
        wl-clipboard
        wl-clip-persist
    ];

    windows = with pkgs; [
        wine-staging
        winetricks
    ];
in
{
    home.packages =
        custom ++ development ++ desktop ++ media ++ theming ++ terminal ++ utilities ++ windows;
}
