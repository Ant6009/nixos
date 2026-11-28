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
    extraNixosModules = [
      {
        # CapsLock: Control when held, Escape when tapped.
        services.keyd = {
          enable = true;
          keyboards.default = {
            ids = [ "*" ];
            settings = {
              main.capslock = "overload(control, esc)";
            };
          };
        };
      }
      {
        # Fingerprint unlock for Ly and other PAM services.
        services.fprintd = {
          enable = true;
          enablePam = true;
        };
        # throttled introspects org.freedesktop.UPower on the system bus.
        services.upower.enable = true;
      }
    ];
    extraHomeModules = [
      {
        # Touchpad: remove the shared -1.0 sensitivity reduction.
        rocinante.input.sensitivity = 0.0;
        # Hyprlock reads the fingerprint directly over fprintd's D-Bus API.
        programs.hyprlock.settings.auth.fingerprint.enabled = true;
        # Rofi: double the width and roughly halve the height by halving the
        # number of visible rows (7 -> 3).
        rocinante.rofi = {
          width = "40%";
          lines = 3;
        };
      }
    ];
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
