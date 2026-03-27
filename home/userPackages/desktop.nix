{ pkgs }:
with pkgs;
[
  adw-gtk3
  bibata-cursors
  bluetui
  feh
  fuzzel
  gamescope
  google-chrome
  gparted
  gpu-screen-recorder
  kitty
  libreoffice-fresh
  libnotify
  lutris
  mangohud
  mpv
  networkmanagerapplet
  nwg-look
  noctalia-shell
  (obs-studio.override { browserSupport = false; })
  pavucontrol
  qq
  satty
  seahorse
  splayer
  sunshine
  tela-circle-icon-theme
  typora
  wechat
  wl-clipboard
  wl-clip-persist
  xwayland-satellite
  zathura
  zathuraPkgs.zathura_pdf_poppler
  kdePackages.qt6ct
]
