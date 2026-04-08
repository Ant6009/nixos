{...}: {
  flake.nixosModules.services = {...}: {
    services.printing.enable = false;
    services.devmon.enable = true;
    services.udisks2.enable = true;
    services.gvfs.enable = true;
    services.locate.enable = true;
    services.openssh.enable = true;
  };
}
