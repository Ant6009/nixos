{...}: {
  flake.nixosModules.boot = {config, ...}: {
    boot = {
      kernelParams = ["quiet" "splash"];
      loader.efi.canTouchEfiVariables = true;
      loader.systemd-boot.enable = true;
      # Keep the three newest generations on the ESP. The installer writes an
      # entry for each of them and garbage-collects older entries plus their
      # kernel/initrd copies, so /boot/loader/entries does not grow forever.
      loader.systemd-boot.configurationLimit = 3;

      kernelModules = ["v4l2loopback"];
      extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
      '';
    };
  };
}
