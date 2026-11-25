{
  self,
  inputs,
  ...
}: let
  mkNixosHost = (import ../../lib/mkNixosHost.nix {inherit self inputs;}).mkNixosHost;

  userConfig = {
    name = "antoine";
    email = "ant.rivoire@gmail.com";
    fullName = "Antoine Rivoire";
    avatar = ../../files/avatar/face;
    gitKey = "E4B6639BFD0391F3";
  };
in {
  flake.nixosConfigurations.razorback = mkNixosHost {
    hostname = "razorback";
    inherit userConfig;
    hardwareModules = [
      inputs.hardware.nixosModules.lenovo-thinkpad-t490
      inputs.hardware.nixosModules.common-pc-ssd
      ../../hosts/razorback/hardware-configuration.nix
      {
        # T490 UHD 620 is Gen9: use the legacy compute runtime. Leave the
        # media runtime at the current default (OneVPL); intel-media-sdk is
        # marked insecure in nixpkgs.
        hardware.intelgpu.computeRuntime = "legacy";

        hardware.enableRedistributableFirmware = true;
        hardware.cpu.intel.updateMicrocode = true;

        services.fwupd.enable = true;
      }
    ];
  };
}
