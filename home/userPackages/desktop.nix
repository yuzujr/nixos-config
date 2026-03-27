{ lib, pkgs }:
let
  sessionPackages = with pkgs; [
    bluetui
    cliphist
    dconf
    fuzzel
    kitty
    libnotify
    networkmanagerapplet
    pavucontrol
    playerctl
    seahorse
    wev
    wl-clipboard
    wl-clip-persist
    xwayland-satellite
  ];

  themePackages = with pkgs; [
    adw-gtk3
    bibata-cursors
    noctalia-shell
    nwg-look
    tela-circle-icon-theme
    kdePackages.qt6ct
  ];

  productivityPackages = with pkgs; [
    google-chrome
    libreoffice-fresh
    (obs-studio.override { browserSupport = false; })
    typora
  ];

  mediaPackages = with pkgs; [
    feh
    ffmpeg
    gpu-screen-recorder
    mpv
    sunshine
    satty
    splayer
    zathura
    zathuraPkgs.zathura_pdf_poppler
  ];

  gamingPackages = with pkgs; [
    gamescope
    lutris
    mangohud
  ];

  communicationPackages = with pkgs; [
    qq
    wechat
  ];

  adminPackages = with pkgs; [
    gparted
  ];
in
lib.concatLists [
  sessionPackages
  themePackages
  productivityPackages
  mediaPackages
  gamingPackages
  communicationPackages
  adminPackages
]
