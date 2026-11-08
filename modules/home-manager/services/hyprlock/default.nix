{config, ...}: let
  # Rocinante / The Expanse MCRN tactical-display palette, variant selected by
  # the rocinante.palette option (see modules/home-manager/theme/palette.nix).
  palette = import ../../theme/palette.nix;
  p = palette.for config.rocinante.palette;
  cyan = "rgb(${p.primary})"; # holographic primary
  cyanDim = "rgb(${p.dim})"; # muted hologram
  amber = "rgb(${p.amber})"; # tactical accent / verifying
  alert = "rgb(${p.alert})"; # access denied
  navy = "rgba(0a1419ee)"; # dark panel fill (ink, identical in every variant)
in {
  programs.hyprlock = {
    enable = true;

    settings = {
      background = {
        path = "screenshot"; # "screenshot" means Hyprlock will take a screenshot of your desktop and blur it

        blur_passes = 3;
        blur_size = 8;

        brightness = 0.55;
        contrast = 1.1;

        # Deep navy tint over the blurred screenshot — the Roci's bridge at night
        color = "rgba(05101dcc)";
      };

      input-field = {
        size = "280, 55";

        outline_thickness = 2;
        rounding = 2; # angular, military hardware

        dots_size = 0.25;
        dots_spacing = 0.25;
        dots_center = true;

        outer_color = cyan;
        inner_color = navy;
        font_color = cyan;
        check_color = amber; # outline while verifying
        fail_color = alert; # outline on wrong code

        fade_on_empty = false;
        placeholder_text = "ENTER PASSWORD";
        fail_text = "<b>ACCESS DENIED</b> — ATTEMPT $ATTEMPTS";

        capslock_color = amber;
        font_family = "JetBrainsMono Nerd Font";

        hide_input = false;
        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      label = [
        # Ship's clock — large, top of the display
        {
          text = "$TIME";
          color = cyan;
          font_size = 64;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 230";
          halign = "center";
          valign = "center";
        }
        # Ship identity
        {
          text = "ROCINANTE";
          color = cyan;
          font_size = 40;
          font_family = "JetBrainsMono Nerd Font ExtraBold";
          position = "0, 130";
          halign = "center";
          valign = "center";
        }
        # Service record subtitle
        {
          text = "";
          color = amber;
          font_size = 14;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 90";
          halign = "center";
          valign = "center";
        }
        # Auth prompt under the input field
        {
          text = "";
          color = cyanDim;
          font_size = 13;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -90";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
