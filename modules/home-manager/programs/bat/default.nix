{...}: {
  # Install bat via home-manager module
  programs.bat = {
    enable = true;
    # Coldark-Cold is the built-in scheme closest to the ship palette
    # (cool blue-greys on a dark ground). The surrounding terminal palette is
    # already Rocinante, see programs/alacritty. Replaces the Catppuccin one,
    # which was injected as programs.bat.config.theme by the catppuccin module.
    config.theme = "Coldark-Cold";
  };
}
