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
  flake.nixosConfigurations.rocinante = mkNixosHost {
    hostname = "rocinante";
    inherit userConfig;
    hardwareModules = [
      inputs.hardware.nixosModules.common-cpu-amd
      inputs.hardware.nixosModules.common-gpu-amd
      inputs.hardware.nixosModules.common-pc-ssd
      ../../hosts/rocinante/hardware-configuration.nix
      ../../hosts/rocinante/sops.nix
    ];
  };
}
