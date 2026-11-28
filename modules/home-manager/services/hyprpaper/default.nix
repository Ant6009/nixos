{
  config,
  pkgs,
  ...
}: {
  # ... other Home Manager configurations ...

  services.hyprpaper = {
    enable = true;
    settings = {
      # Important: Enable IPC so hyprctl can interact with hyprpaper
      ipc = "on";

      splash = false;

      wallpaper = {
        # Empty monitor is hyprpaper's fallback: every monitor without a
        # wallpaper-specific entry gets this image.
        monitor = "";
        path = "/home/antoine/Pictures/wallpaper";
        order = "random";
        # hyprpaper shuffles the directory at startup, then rotates after
        # this timeout. Keep it longer than any session to pick once.
        timeout = 2147483647;
      };
    };
  };
}
