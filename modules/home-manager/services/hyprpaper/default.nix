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
      splash_offset = 2.0;

      preload = ["/home/antoine/Pictures/wallpaper/expanse1.jpg"];

      wallpaper = [",/home/antoine/Pictures/wallpaper/expanse1.jpg"];
    };
  };
}
