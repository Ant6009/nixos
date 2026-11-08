# Rocinante console palette: the single source of truth for the colours used
# across the home-manager surfaces (hyprland, waybar, hyprlock, gtk, tmux,
# alacritty, nvf, starship, btop, rofi, ulauncher, wlogout, dunst).
#
# Select a variant with the `rocinante.palette` option declared in
# modules/home-manager/theme/default.nix, set per host in dendritic/flake/:
#
#   rocinante.palette = "classic" | "faded" | "patina" | "steel";
#
# Role names are stable across variants, only chroma and lightness move:
#   classic  the original bright MCRN hologram (kept selectable)
#   faded    same hue family, desaturated and dimmed: hologram seen through scratched glass
#   patina   hue drifts toward oxidised copper, accents become ochre and rust
#   steel    chroma collapses toward gunmetal, cyan survives as a faint cast
#
# The inks (text, fill foreground, panel fills) are identical in every variant
# on purpose: terminal and code legibility must not depend on a decoration
# choice. Contrast against the panel fill #0a1419:
#   classic  primary 11.7  dim 4.5  amber 10.6  green 10.2  alert 5.7
#   faded     primary  7.7  dim 3.6  amber  8.3  green  7.8  alert 4.9
#   patina    primary  6.7  dim 3.7  amber  6.7  green  6.2  alert 4.8
#   steel     primary  5.8  dim 3.7  amber  7.3  green  5.5  alert 4.6
let
  # Roles that weather. Anything not listed here is identical in all variants.
  weatheredRoles = [
    "primary"
    "dim"
    "light"
    "muted"
    "faint"
    "amber"
    "alert"
    "alertMid"
    "green"
    "phosphor"
  ];

  hexDigits = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    a = 10;
    b = 11;
    c = 12;
    d = 13;
    e = 14;
    f = 15;
  };

  byteOf = hex: i: (hexDigits.${builtins.substring (2 * i) 1 hex}) * 16 + (hexDigits.${builtins.substring (2 * i + 1) 1 hex});

  # "2de2e6" -> "45, 226, 230", the form CSS rgba() triples use here.
  toRgbTriple = hex: builtins.concatStringsSep ", " (map (i: builtins.toString (byteOf hex i)) [ 0 1 2 ]);

  variants = {
    classic = {
      primary = "2de2e6";
      dim = "1a8a8f";
      light = "7dd3d8";
      muted = "96b8bf";
      faint = "5c8189";
      amber = "ffb454";
      alert = "ff4d4d";
      alertMid = "de5255";
      green = "4fd6a0";
      phosphor = "7ccd75";

      text = "dceef2";
      textOnFill = "05101d";
      panel = "0a1419";
      panelDeep = "05101d";
    };

    faded = {
      primary = "46b6b9";
      dim = "35777a";
      light = "83babd";
      muted = "93a9ad";
      faint = "5d7074";
      amber = "dea154";
      alert = "eb4744";
      alertMid = "ca494a";
      green = "4ebb8f";
      phosphor = "74b76f";

      text = "dceef2";
      textOnFill = "05101d";
      panel = "0a1419";
      panelDeep = "05101d";
    };

    patina = {
      primary = "49ab98";
      dim = "3a796e";
      light = "80b6ae";
      muted = "8fa7a6";
      faint = "596d6c";
      amber = "d18c52";
      alert = "df5149";
      alertMid = "c0504d";
      green = "51a66d";
      phosphor = "81a86c";

      text = "dceef2";
      textOnFill = "05101d";
      panel = "0a1419";
      panelDeep = "05101d";
    };

    steel = {
      primary = "7295a1";
      dim = "58737d";
      light = "9fafb6";
      muted = "a5abb0";
      faint = "6d7478";
      amber = "c39b60";
      alert = "d0574e";
      alertMid = "b3544f";
      green = "61967a";
      phosphor = "7f9d77";

      text = "dceef2";
      textOnFill = "05101d";
      panel = "0a1419";
      panelDeep = "05101d";
    };
  };
in
{
  inherit variants weatheredRoles toRgbTriple;

  # The selected variant as a role -> hex attrset (no leading #).
  for = name: variants.${name} or variants.classic;

  # Rewrite a checked-in file that carries the classic colours. Both spellings
  # are handled: the bare/#-prefixed hex (hyprland rgba(...ee), CSS #hex) and
  # the decimal triples CSS rgba() uses here. Bare-hex replacement also covers
  # the # form, since "#2de2e6" contains "2de2e6".
  substitute = name: text:
    let
      from = builtins.map (r: variants.classic.${r}) weatheredRoles
        ++ builtins.map (r: toRgbTriple variants.classic.${r}) weatheredRoles;
      to = builtins.map (r: variants.${name}.${r}) weatheredRoles
        ++ builtins.map (r: toRgbTriple variants.${name}.${r}) weatheredRoles;
    in
      builtins.replaceStrings from to text;
}
