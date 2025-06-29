{nhModules, ...}: {
  imports = [
    "${nhModules}/common"
    "${nhModules}/desktop/hyprland"
    "${nhModules}/programs/zoom"
    "${nhModules}/services/easyeffects"
    "${nhModules}/services/ulauncher"
    "${nhModules}/programs/nvf"
    "${nhModules}/services/hyprpaper"
    "${nhModules}/services/hyprlock"
    "${nhModules}/misc/wallpaper"
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
