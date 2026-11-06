{...}: {
  # Install btop via home-manager module
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      color_theme = "rocinante.theme";
    };
  };

  # Console palette theme file, replacing the Catppuccin one.
  xdg.configFile."btop/themes/rocinante.theme".source = ./rocinante.theme;
}
