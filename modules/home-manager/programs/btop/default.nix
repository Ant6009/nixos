{ config, ... }:
let
  palette = import ../../theme/palette.nix;
in {
  # Install btop via home-manager module
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      color_theme = "rocinante.theme";
    };
  };

  # Console palette theme file, replacing the Catppuccin one. The checked-in
  # theme carries the classic colours; substitute rewrites them (and the edge
  # alphas) for the host's rocinante.palette.
  xdg.configFile."btop/themes/rocinante.theme".text = palette.substitute config.rocinante.palette (builtins.readFile ./rocinante.theme);
}
