{
    vars,
    ...
}:
{
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ vars.username ];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
}
