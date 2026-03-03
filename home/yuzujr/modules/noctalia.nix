{ inputs, pkgs, ... }:

let
  noctaliaConfigDir = ../dotfiles/.config/noctalia;
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = builtins.fromJSON (builtins.readFile (noctaliaConfigDir + "/settings.json"));
    colors = builtins.fromJSON (builtins.readFile (noctaliaConfigDir + "/colors.json"));
    plugins = builtins.fromJSON (builtins.readFile (noctaliaConfigDir + "/plugins.json"));
    user-templates = noctaliaConfigDir + "/user-templates.toml";
  };
}
