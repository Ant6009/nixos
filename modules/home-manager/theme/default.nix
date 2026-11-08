{
  lib,
  ...
}: {
  # Which variant of the Rocinante palette the whole home renders with.
  # Data lives in ./palette.nix; set the value per host in dendritic/flake/.
  options.rocinante.palette = lib.mkOption {
    type = lib.types.enum [
      "classic"
      "faded"
      "patina"
      "steel"
    ];
    default = "classic";
    example = "faded";
    description = "Rocinante palette variant: classic (bright MCRN hologram), faded (desaturated hologram), patina (oxidised copper), steel (gunmetal).";
  };
}
