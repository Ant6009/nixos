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
      ipc = true;

      # Preload the wallpaper. This makes it available for hyprpaper to use.
      preload = ["/home/antoine/Pictures/wallpaper/expanse1.jpg"];

      # Set the wallpaper for ALL monitors.
      # The format is "monitorName,path/to/wallpaper.jpg"
      # An empty string for monitorName means "all monitors" or "the default monitor".
      wallpaper = [",/home/antoine/Pictures/wallpaper/expanse1.jpg"];

      # If you have multiple monitors and want to set it for a specific one,
      # find its name using 'hyprctl monitors' and replace the empty string:
      # wallpaper = [ "DP-1,/home/antoine/Pictures/wallpaper/expanse1.jpg" ];
      # wallpaper = [ "HDMI-A-1,/home/antoine/Pictures/wallpaper/expanse1.jpg" ];
    };
  };
}
