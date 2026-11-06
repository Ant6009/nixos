{
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
    # Install OBS Studio via home-manager module
    programs.obs-studio.enable = true;

    # Rocinante console theme for OBS, layered onto OBS's own Yami theme by
    # remapping its colour variables (see Rocinante.ovt). Replaces the
    # Catppuccin .ovt/.obt the catppuccin module used to drop here.
    # OBS stores its chosen theme in ~/.config/obs-studio/global.ini, which it
    # rewrites itself, so pick "Rocinante" once in OBS > Settings > General.
    xdg.configFile."obs-studio/themes/Rocinante.ovt".source = ./Rocinante.ovt;
  };
}
