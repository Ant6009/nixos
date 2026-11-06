{pkgs, ...}: let
  rofiTheme = pkgs.writeText "rocinante.rasi" (builtins.readFile ./rocinante.rasi);
in {
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
      lines = 7;
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
}
