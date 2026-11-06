{...}: {
  # Starship configuration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      directory = {
        style = "bold lavender";
      };
      aws = {
        disabled = true;
      };
      docker_context = {
        symbol = " ";
      };
      golang = {
        symbol = " ";
      };
      kubernetes = {
        disabled = false;
        style = "bold pink";
        symbol = "󱃾 ";
        format = "[$symbol$context( \($namespace\))]($style)";
        contexts = [
          {
            context_pattern = "arn:aws:eks:(?P<var_region>.*):(?P<var_account>[0-9]{12}):cluster/(?P<var_cluster>.*)";
            context_alias = "$var_cluster";
          }
        ];
      };
      helm = {
        symbol = " ";
      };
      gradle = {
        symbol = " ";
      };
      java = {
        symbol = " ";
      };
      kotlin = {
        symbol = " ";
      };
      lua = {
        symbol = " ";
      };
      package = {
        symbol = " ";
      };
      php = {
        symbol = " ";
      };
      python = {
        symbol = " ";
      };
      terraform = {
        symbol = " ";
      };
      right_format = "$kubernetes";

      # Rocinante console palette instead of Catppuccin. The role names are
      # kept from the Catppuccin set so existing styles ("bold lavender",
      # "bold pink") resolve to ship colors, and starship's own ANSI colors
      # (green/yellow/red) already pick up the themed alacritty palette.
      palette = "rocinante";
      palettes.rocinante = {
        rosewater = "#dceef2";
        flamingo = "#e88b86";
        pink = "#f5b0ab";
        mauve = "#2de2e6";
        red = "#ff4d4d";
        maroon = "#ff8080";
        peach = "#ffb454";
        yellow = "#ffd08a";
        green = "#4fd6a0";
        teal = "#2de2e6";
        turquoise = "#7ff0b5";
        sky = "#7dd3d8";
        sapphire = "#6fc0d8";
        blue = "#2d8fb5";
        lavender = "#7dd3d8";
        text = "#dceef2";
        subtext1 = "#b6d4da";
        subtext0 = "#96b8bf";
        overlay2 = "#7ba3ab";
        overlay1 = "#5c8189";
        overlay0 = "#46666e";
        surface2 = "#233a45";
        surface1 = "#1a8a8f";
        surface0 = "#12232c";
        mantle = "#0d1a24";
        crust = "#05101d";
        base = "#0a1419";
      };
    };
  };
}
