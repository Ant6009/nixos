{
  userConfig,
  pkgs,
  ...
}: {
  # GTK theme configuration
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    font = {
      name = "Roboto";
      size = 11;
    };
    gtk4.theme = {
      name = "Catppuccin Mocha";
      package = pkgs.catppuccin-gtk;  # provided by catppuccin overlay
    };
    gtk3.theme = {
      name = "Catppuccin Mocha";
      package = pkgs.catppuccin-gtk;
    };
    gtk3 = {
      bookmarks = [
        "file:///home/${userConfig.name}/Documents"
        "file:///home/${userConfig.name}/Downloads"
        "file:///home/${userConfig.name}/Pictures"
        "file:///home/${userConfig.name}/Videos"
        "file:///home/${userConfig.name}/Downloads/temp"
        "file:///home/${userConfig.name}/Documents/repositories"
      ];
    };
  };

  # Catppuccin GTK theme (package from catppuccin overlay).
  # The catppuccin HM module API changed; set theme directly instead.
  home.packages = [ pkgs.catppuccin-gtk ];
}
