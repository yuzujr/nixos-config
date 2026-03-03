{ inputs, pkgs, ... }:

let
  noctaliaConfigDir = ../dotfiles/.config/noctalia;
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = noctaliaConfigDir + "/settings.json";
    colors = noctaliaConfigDir + "/colors.json";
    plugins = noctaliaConfigDir + "/plugins.json";
    user-templates = noctaliaConfigDir + "/user-templates.toml";
  };
}
