{
  myvars,
  ...
}:
{
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ myvars.username ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
