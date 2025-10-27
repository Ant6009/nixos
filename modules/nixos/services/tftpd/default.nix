{pkgs, ...}: {
  services.atftpd = {
    enable = true;
    root = "/srv/tftp";
    extraOptions = [
      "--bind-address 192.168.0.66"
      "--verbose=7"
      "--port=69"
    ];
  };
}
