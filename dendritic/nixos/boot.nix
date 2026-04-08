{...}: {
  flake.nixosModules.boot = {config, ...}: {
    boot = {
      kernelParams = ["quiet" "splash"];
      loader.efi.canTouchEfiVariables = true;
      loader.systemd-boot.enable = true;

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
