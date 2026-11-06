{...}: {
  # Install bat via home-manager module
  programs.bat = {
    enable = true;
    settings = {
      # Coldark-Cold is the built-in scheme closest to the ship palette
      # (cool blue-greys on a dark ground); the surrounding terminal palette
      # is already Rocinante, see programs/alacritty.
      theme = "Coldark-Cold";
    };
  };
}
