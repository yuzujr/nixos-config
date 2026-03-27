{ lib, pkgs }:
let
  shellPackages = with pkgs; [
    codex
    delta
    eza
    fzf
    starship
    yazi
    zoxide
  ];

  terminalTools = with pkgs; [
    btop
    csvlens
    duf
    dust
    fastfetch
  ];

  funPackages = with pkgs; [
    cmatrix
    nyancat
  ];
in
lib.concatLists [
  shellPackages
  terminalTools
  funPackages
]
