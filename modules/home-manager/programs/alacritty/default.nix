{pkgs, ...}: {
  # Install alacritty via home-manager module
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        live_config_reload = true;
      };

      terminal = {
        shell.program = "zsh";
        shell.args = [
          "-l"
          "-c"
          "tmux attach || tmux "
        ];
      };

      env = {
        TERM = "xterm-256color";
      };

      window = {
        decorations =
          if pkgs.stdenv.hostPlatform.isDarwin
          then "buttonless"
          else "none";
        dynamic_title = false;
        dynamic_padding = true;
        opacity = 0.85;
        dimensions = {
          columns = 170;
          lines = 45;
        };
        padding = {
          x = 5;
          y = 1;
        };
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        size =
          if pkgs.stdenv.hostPlatform.isDarwin
          then 15
          else 12;
        normal = {
          family = "MesloLGS Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "MesloLGS Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "MesloLGS Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "MesloLGS Nerd Font";
          style = "Italic";
        };
      };

      selection = {
        semantic_escape_chars = '',│`|:"' ()[]{}<>'';
        save_to_clipboard = true;
      };

      # Rocinante / MCRN console palette (shared with hyprland, hyprlock,
      # waybar and ~/.pi/agent/themes/rocinante.json)
      colors = {
        primary = {
          background = "#05101d";
          foreground = "#dceef2";
        };

        normal = {
          black = "#0a1419";
          blue = "#2d8fb5";
          cyan = "#2de2e6";
          green = "#4fd6a0";
          magenta = "#e88b86";
          red = "#ff4d4d";
          white = "#cfe3e7";
          yellow = "#ffb454";
        };

        bright = {
          black = "#5c8189";
          blue = "#6fc0d8";
          cyan = "#7dd3d8";
          green = "#7ff0b5";
          magenta = "#f5b0ab";
          red = "#ff8080";
          white = "#eafcff";
          yellow = "#ffd08a";
        };

        selection = {
          background = "#1a8a8f";
          text = "#eafcff";
        };

        # Search highlight colours. In alacritty 0.17 footer_bar sits under
        # colors (not under colors.search), and search has focused_match + matches.
        search = {
          focused_match = {
            background = "#ffb454";
            foreground = "#05101d";
          };
          matches = {
            background = "#1a8a8f";
            foreground = "#eafcff";
          };
        };

        footer_bar = {
          background = "#1a8a8f";
          foreground = "#eafcff";
        };

        hints = {
          start = {
            background = "#ffb454";
            foreground = "#05101d";
          };
          end = {
            background = "#1a8a8f";
            foreground = "#eafcff";
          };
        };
      };
    };
  };
}
