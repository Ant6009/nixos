{ lib, pkgs, config, ... }: let
  palette = import ../../theme/palette.nix;
  cfg = config.rocinante.rofi;

  # The checked-in .rasi carries the classic colours; rewrite them, and the
  # edge alphas, for the host's rocinante.palette. Geometry is substituted too,
  # so each host can tune width/height without forking the theme.
  rofiTheme = pkgs.writeText "rocinante.rasi" (
    builtins.replaceStrings [ "@ROFI_WIDTH@" ] [ cfg.width ]
      (palette.substitute config.rocinante.palette (builtins.readFile ./rocinante.rasi))
  );
in {
  options.rocinante.rofi = {
    width = lib.mkOption {
      type = lib.types.str;
      default = "20%";
      example = "40%";
      description = "Rofi window width as a percentage of the monitor.";
    };
    lines = lib.mkOption {
      type = lib.types.int;
      default = 7;
      example = 3;
      description = "Visible rows in the Rofi list; this drives window height.";
    };
  };

  config = {
    home.packages = [pkgs.papirus-icon-theme];

    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      theme = "${rofiTheme}";
      # rofi 2.x renamed extraConfig -> settings (and terminal moved under it).
      # Window width and position live in the theme now (see rocinante.rasi).
      settings = {
        terminal = "${pkgs.alacritty}/bin/alacritty";
        modi = "drun,run";
        lines = cfg.lines;
        show-icons = true;
        display-drun = " ";
        display-run = " ";
        drun-display-format = "{name}";
        icon-theme = "Papirus-Dark";
        matching = "fuzzy";
        sort = true;
        sorting-method = "fzf";
        steal-focus = true;
      };
    };
  };
}
