{...}: {
  flake.nixosModules.packages = {pkgs, ...}: {
    environment.localBinInPath = true;

    environment.systemPackages = with pkgs; [
      gcc
      glib
      gnumake
      killall
      mesa
      unzip
      wget
      curl
      kitty
      firefox
      vim
      home-manager
      quickemu
      shotcut
      bitwig-studio-latest
      cardinal
      nmap
      tcpdump
      zoxide
      sox
      bc
      qjackctl
      alsa-utils
      ffmpeg
      vcv-rack
      google-chrome
    ];
  };
}
