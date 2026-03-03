{ inputs, pkgs, lib, ... }:

let
  noctaliaConfigDir = ../dotfiles/.config/noctalia;
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  # Copy noctalia config as writable files so noctalia can change color schemes and apply templates
  home.activation.noctaliaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    configDir="$HOME/.config/noctalia"
    $DRY_RUN_CMD mkdir -p "$configDir"
    while IFS= read -r -d "" f; do
      dest="$configDir/$(basename "$f")"
      if [ ! -e "$dest" ]; then
        $DRY_RUN_CMD cp "$f" "$dest"
        $DRY_RUN_CMD chmod u+w "$dest"
      fi
    done < <(find ${noctaliaConfigDir} -maxdepth 1 -type f -print0)
  '';
}
