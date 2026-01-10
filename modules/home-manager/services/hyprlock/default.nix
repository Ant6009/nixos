{config, ...}: {
  programs.hyprlock = {
    enable = true;

    settings = {
      background = {
        path = "screenshot"; # "screenshot" means Hyprlock will take a screenshot of your desktop and blur it

        blur_passes = 2;
        blur_size = 7;

        brightness = 0.8;
        contrast = 0.8;

        # Replaced ${base00}99 with a dark gray with 99 (60%) transparency
        color = "rgb(282828)99"; # Example: Dark gray with 60% alpha (99 in hex)
      };

       input-field = {
         /*size = {
          width = 200;
          height = 50;
        };*/

        outline_thickness = 3;
        dots_size = 0.33;
        dots_spacing = 0.15;
        dots_center = false;
        # Replaced ${base01} with a slightly lighter dark gray
        outer_color = "rgb(3c3836)"; # Example: Slightly lighter dark gray
        # Replaced ${base07} with a light gray/white
        inner_color = "rgb(ebdbb2)"; # Example: Light gray/off-white
        # Replaced ${base00} with a dark gray
        font_color = "rgb(282828)"; # Example: Dark gray
        fade_on_empty = true;
        placeholder_text = "<i>Input Password...</i>";
        hide_input = false;
        position = {
          x = 0;
          y = -20;
        };
        halign = "center";
        valign = "center";
      };

      label = {
        text = "$TIME";
        # Replaced ${base05} with a medium gray
        color = "rgb(a89984)"; # Example: Medium gray
        font_size = 50;
        font_family = "Noto Sans";
        position = {
          x = 0;
          y = 80;
        };
        halign = "center";
        valign = "center";
      };
    };
  };
}
