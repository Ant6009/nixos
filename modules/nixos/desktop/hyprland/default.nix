{
  config,
  pkgs,
  ...
}: {
  # Enable Hyprland with uwsm session management
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Ly is a console TUI display manager. It replaces greetd + tuigreety,
  # reads the Hyprland session desktop entries, and remembers the last
  # selected session by default (save_file_dir in ly's config).
  services.displayManager.ly = {
    enable = true;
  };


  # Enables support for Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable Bluetooth support
  services.blueman.enable = true;

  # Enable security services
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services = {
    hyprlock = {};
    ly.enableGnomeKeyring = true;
  };

  # Enable Ozone Wayland support in Chromium and Electron based applications
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XCURSOR_SIZE = "24";
  };

  # List of Hyprland specific packages
  environment.systemPackages = with pkgs; [
    file-roller # archive manager
    gnome-calculator
    gnome-pomodoro
    gnome-text-editor
    loupe # image viewer
    nautilus # file manager
    seahorse # keyring manager
    totem # Video player

    hyprpicker

    brightnessctl
    grim
    libnotify
    networkmanagerapplet
    pamixer
    slurp
    wf-recorder
    wlr-randr
    wlsunset
  ];
}
