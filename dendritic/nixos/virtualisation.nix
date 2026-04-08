{...}: {
  flake.nixosModules.virtualisation = {...}: {
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.libvirtd.enable = true;
  };
}
