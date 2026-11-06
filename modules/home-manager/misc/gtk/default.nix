{
  userConfig,
  pkgs,
  ...
}: let
  # Rocinante / MCRN console palette, layered onto plain Adwaita (dark)
  # through GTK named colors. Adwaita reads these variables, so selection,
  # headerbar, popover, tooltip and scrollbar colors all follow the same
  # palette as hyprland.conf, hyprlock, waybar/style.css, alacritty and
  # ~/.pi/agent/themes/rocinante.json.
  consolePaletteCss = ''
    @define-color window_bg_color #05101d;
    @define-color window_fg_color #dceef2;

    @define-color theme_bg_color #05101d;
    @define-color theme_fg_color #dceef2;
    @define-color theme_base_color #0a1419;
    @define-color theme_text_color #dceef2;
    @define-color theme_secondary_text_color #96b8bf;
    @define-color theme_unfocused_fg_color #96b8bf;
    @define-color theme_unfocused_text_color #96b8bf;
    @define-color theme_unfocused_base_color #0a1419;

    @define-color accent_color #2de2e6;
    @define-color accent_bg_color #2de2e6;
    @define-color accent_fg_color #05101d;
    @define-color theme_selected_bg_color #1a8a8f;
    @define-color theme_selected_fg_color #eafcff;

    @define-color success_color #4fd6a0;
    @define-color warning_color #ffb454;
    @define-color error_color #ff4d4d;
    @define-color destructive_color #ff4d4d;

    @define-color headerbar_bg_color #0a1419;
    @define-color headerbar_fg_color #dceef2;
    @define-color headerbar_border_color #1a8a8f;
    @define-color headerbar_backdrop_color #05101d;

    @define-color card_bg_color #0a1419;
    @define-color card_fg_color #dceef2;
    @define-color popover_bg_color #0a1419;
    @define-color popover_fg_color #dceef2;
    @define-color popover_shaded_background_color #12232c;
    @define-color tooltip_bg_color #0a1419;
    @define-color tooltip_fg_color #dceef2;

    @define-color view_bg_color #05101d;
    @define-color view_fg_color #dceef2;
    @define-color scrollbar_bg_color #0a1419;
    @define-color scrollbar_slider_color #1a8a8f;
    @define-color scrollbar_hover_slider_color #2de2e6;

    @define-color border_color #1a8a8f;
    @define-color unfocused_border_color #12232c;
  '';
in {
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

    gtk3.theme = {
      name = "Adwaita-dark";
    };
    gtk4.theme = {
      name = "Adwaita";
    };

    # Home-manager's gtk module is split per GTK version: extra CSS goes in
    # gtk.gtk3.extraCss / gtk.gtk4.extraCss (there is no gtk.extraConfig).
    gtk3.extraCss = consolePaletteCss;
    gtk4.extraCss = consolePaletteCss;

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
}
