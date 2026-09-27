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

  # greetd display manager with tuigreety (active tuigreet-compatible fork,
  # same binary name and CLI; upstream tuigreet is stale).
  # nixpkgs has no tuigreety yet — built from the flake input via overlay
  # (see dendritic/flake/rocinante.nix).
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # DIAGNOSTIC: file debug log for the AUTH_ERR investigation
        # (journal showed pam AUTH_ERR on the new generation; secrets are
        # redacted from this log by the fork). Remove once resolved.
        command = "${pkgs.tuigreety}/bin/tuigreet --time --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --debug /var/cache/tuigreet/debug.log";
        user = "greeter";
      };
    };
  };

  # --- Alternative: wlgreet (graphical Wayland greeter) ---
  # wlgreet is a wlr-layer-shell client: greetd launches a dedicated
  # Hyprland instance (greeter user) that runs wlgreet on startup; on
  # login wlgreet starts the user session and the greeter instance exits.
  # To try it, create /etc/hyprland/greetd.conf with at least:
  #   exec-once = wlgreet; hyprctl exit
  # then swap the default_session above for:
  #   command = "${pkgs.hyprland}/bin/Hyprland --config /etc/hyprland/greetd.conf";
  # and add pkgs.wlgreet to environment.systemPackages.


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
    greetd.enableGnomeKeyring = true;
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
