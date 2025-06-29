{lib, ...}: {
  options.wallpaper = lib.mkOption {
    type = lib.types.path;
    default = "/home/antoine/Pictures/wallpaper/expanse1.jpg";
    readOnly = true;
    description = "Path to default wallpaper";
  };
}
