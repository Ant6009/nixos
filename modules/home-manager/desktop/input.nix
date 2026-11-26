{ lib, ... }: {
  options.rocinante.input = {
    sensitivity = lib.mkOption {
      type = lib.types.float;
      default = -1.0;
      example = 0.0;
      description = "Hyprland pointer sensitivity: -1.0 to 1.0, 0 means no modification.";
    };
  };
}
