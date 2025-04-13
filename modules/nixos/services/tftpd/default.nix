{
  config,
  pkgs,
  ...
}: {
  services.tfptd = {
    enable = true;
    path = "/srv/tftp";
    port = 69;
  };
}
