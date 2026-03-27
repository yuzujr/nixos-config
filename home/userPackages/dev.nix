{ lib, pkgs }:
let
  buildPackages = with pkgs; [
    cmake
    gnumake
  ];

  editorPackages = with pkgs; [
    emacs-pgtk
    emacsPackages.vterm
    neovim
    vscode
  ];

  nixPackages = with pkgs; [
    nixd
    nixfmt
  ];

  lintPackages = with pkgs; [
    shellcheck
  ];
in
lib.concatLists [
  buildPackages
  editorPackages
  nixPackages
  lintPackages
]
