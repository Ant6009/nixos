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
#
# Edge alphas (hairlines, borders, separators) are scaled down in the weathered
# variants so lines read scratched rather than glowing. Panel fills and the
# translucent background washes are NOT scaled: they carry the plate structure.
let
  # Roles that weather, split in two groups:
  #   weathered  the console roles (borders, plates, accents, status colours)
  #   derived    the syntax tints the terminal surfaces use (alacritty,
  #              starship, nvf): brighter siblings of the accent families plus
  #              the cyan-family blues and the mid-tone text ramp
  # Everything else is identical in all variants: the inks (text, textBright,
  # textOnFill) and the panel fills (panel, panelDeep, panelLit, panelMid).
  weathered = [
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
  derived = [
    "amberBright"
    "alertBright"
    "redLit"
    "redLitSoft"
    "greenBright"
    "blueLight"
    "blueDeep"
    "textMid"
    "overlayMid"
    "overlayDeep"
  ];
  weatheredRoles = weathered ++ derived;

  core = {
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
    };
  };

  tints = {
    classic = {
      amberBright = "ffd08a";
      alertBright = "ff8080";
      redLit = "e88b86";
      redLitSoft = "f5b0ab";
      greenBright = "7ff0b5";
      blueLight = "6fc0d8";
      blueDeep = "2d8fb5";
      textMid = "b6d4da";
      overlayMid = "7ba3ab";
      overlayDeep = "46666e";
    };
    # Kept readable on the deepest panel #05101d: lowest of the set is
    # blueDeep at 3.8:1 (5.2:1 in classic).
    faded = {
      amberBright = "e7be81";
      alertBright = "f07472";
      redLit = "d88079";
      redLitSoft = "e9a19b";
      greenBright = "79daa7";
      blueLight = "78abbb";
      blueDeep = "43768a";
      textMid = "b2c6ca";
      overlayMid = "7a9398";
      overlayDeep = "46565a";
    };
    patina = {
      amberBright = "dcac7c";
      alertBright = "e77a75";
      redLit = "d0837a";
      redLitSoft = "e2a39a";
      greenBright = "78ca89";
      blueLight = "75b3b3";
      blueDeep = "447c80";
      textMid = "adc4c3";
      overlayMid = "769290";
      overlayDeep = "425353";
    };
    steel = {
      amberBright = "d2b687";
      alertBright = "db7d76";
      redLit = "c6837b";
      redLitSoft = "d9a299";
      greenBright = "86bb98";
      blueLight = "96a5b1";
      blueDeep = "607182";
      textMid = "c3c9cd";
      overlayMid = "8d9499";
      overlayDeep = "555b5f";
    };
  };

  inks = {
    text = "dceef2";
    textBright = "eafcff";
    textOnFill = "05101d";
    panel = "0a1419";
    panelDeep = "05101d";
    panelLit = "12232c";
    panelMid = "0d1a24";
  };

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
  hexChars = [
    "0"
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
    "a"
    "b"
    "c"
    "d"
    "e"
    "f"
  ];

  hexPairToInt = pair: hexDigits.${builtins.substring 0 1 pair} * 16 + hexDigits.${builtins.substring 1 1 pair};
  byteOf = hex: i: hexPairToInt (builtins.substring (2 * i) 2 hex);

  # "2de2e6" -> "45, 226, 230", the form the CSS rgba() triples use here.
  toRgbTriple = hex: builtins.concatStringsSep ", " (map (i: builtins.toString (byteOf hex i)) [ 0 1 2 ]);

  # Nix has builtins.div but no modulo builtin.
  mod = a: b: a - b * builtins.div a b;

  intToHexPair = n: builtins.elemAt hexChars (builtins.div n 16) + builtins.elemAt hexChars (mod n 16);

  # Round to two decimals but keep the trailing zero, so 0.20 renders as 0.20.
  toAlpha = x:
    let
      n = builtins.floor (x * 100 + 0.5);
      whole = builtins.div n 100;
      frac = mod n 100;
    in
      builtins.toString whole + "." + (if frac < 10 then "0" else "") + builtins.toString frac;

  variants = {
    classic = core.classic // tints.classic // inks;
    faded = core.faded // tints.faded // inks;
    patina = core.patina // tints.patina // inks;
    steel = core.steel // tints.steel // inks;
  };

  # How much of the classic line alpha survives in each variant.
  edgeScale = {
    classic = 1.0;
    faded = 0.72;
    patina = 0.68;
    steel = 0.62;
  };

  # Edge alphas as written in CSS rgba() triples, per role.
  cssEdgeAlphas = [
    {
      role = "primary";
      alpha = "0.28";
    }
    {
      role = "primary";
      alpha = "0.35";
    }
    {
      role = "primary";
      alpha = "0.45";
    }
    {
      role = "primary";
      alpha = "0.55";
    }
    {
      role = "primary";
      alpha = "0.60";
    }
    {
      role = "dim";
      alpha = "0.25";
    }
    {
      role = "dim";
      alpha = "0.35";
    }
    {
      role = "dim";
      alpha = "0.45";
    }
    {
      role = "amber";
      alpha = "0.60";
    }
  ];

  # Edge alphas appended to the hex, the form Hyprland uses: rgba(2de2e6ee).
  hexEdgeAlphas = [
    {
      role = "primary";
      alpha = "ee";
    }
    {
      role = "dim";
      alpha = "55";
    }
  ];
in
rec {
  inherit variants weatheredRoles toRgbTriple edgeScale;

  # The selected variant as a role -> hex attrset (no leading #).
  for = name: variants.${name} or variants.classic;

  # Rewrite a checked-in file that carries the classic colours. Both spellings
  # are handled: the bare/#-prefixed hex (CSS #hex, hyprland rgba(...ee)) and
  # the decimal triples CSS rgba() uses here. Bare-hex replacement also covers
  # the # form, since "#2de2e6" contains "2de2e6".
  #
  # Full rgba() literals with an edge alpha are replaced first, so the alpha is
  # rescaled for the variant before the plain colour/triple pass runs.
  substitute = name: text:
    let
      v = variants.${name} or variants.classic;
      s = edgeScale.${name} or 1.0;

      cssAlphaFrom = builtins.map (e: "rgba(${toRgbTriple variants.classic.${e.role}}, ${e.alpha})") cssEdgeAlphas;
      cssAlphaTo = builtins.map (e: "rgba(${toRgbTriple v.${e.role}}, ${toAlpha (builtins.fromJSON e.alpha * s)})") cssEdgeAlphas;

      hexAlphaFrom = builtins.map (e: variants.classic.${e.role} + e.alpha) hexEdgeAlphas;
      hexAlphaTo = builtins.map (e: v.${e.role} + intToHexPair (builtins.floor (hexPairToInt e.alpha * s + 0.5))) hexEdgeAlphas;

      colourFrom = builtins.map (r: variants.classic.${r}) weatheredRoles;
      colourTo = builtins.map (r: v.${r}) weatheredRoles;

      tripleFrom = builtins.map (r: toRgbTriple variants.classic.${r}) weatheredRoles;
      tripleTo = builtins.map (r: toRgbTriple v.${r}) weatheredRoles;
    in
      builtins.replaceStrings (cssAlphaFrom ++ hexAlphaFrom ++ colourFrom ++ tripleFrom) (cssAlphaTo ++ hexAlphaTo ++ colourTo ++ tripleTo) text;

  # Same rewrite, applied to every string in an attrset (alacritty colors,
  # starship palettes, dunst settings, nvf config sections).
  substituteAll = name: set: builtins.mapAttrs (_: v: if builtins.isAttrs v then substituteAll name v else if builtins.isString v then substitute name v else v) set;
}
