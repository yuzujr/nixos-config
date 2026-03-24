{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
let
  cfg = config.modules.features.mihomo;
in
{
  options.modules.features.mihomo.enable = lib.mkEnableOption "mihomo service";

  config = lib.mkMerge [
    {
      # ==========================================
      # Gaming
      # ==========================================
      programs.steam.enable = true;

      # ==========================================
      # Virtualization
      # ==========================================
      programs.virt-manager.enable = true;
      users.groups.libvirtd.members = [ myvars.username ];
      virtualisation.libvirtd.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;
    }

    (lib.mkIf cfg.enable {
      services.mihomo = {
        enable = true;
        tunMode = true;
        webui = pkgs.metacubexd;
        configFile = "/etc/agenix/mihomo-config.yaml";
      };
    })
  ];
}
