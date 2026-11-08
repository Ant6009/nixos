{ pkgs, config, ... }: let
  palette = import ../../theme/palette.nix;

  # Hyprland 0.55+ parses `hyprctl dispatch` in the syntax of the *running*
  # config format, which only changes at login. Probe it with a side-effect
  # free dispatcher rather than trusting which config file is on disk.
  hyprLogout = pkgs.writeShellScriptBin "hypr-logout" ''
    if hyprctl dispatch "hl.dsp.no_op()" 2>&1 | grep -q "Invalid dispatcher"; then
      exec hyprctl dispatch exit
    fi
    exec hyprctl dispatch "hl.dsp.exit()"
  '';
in {
  home.packages = with pkgs; [
    wlogout
  ];
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "${hyprLogout}/bin/hypr-logout";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    style = palette.substitute config.rocinante.palette ''
      * {
          background-image: none;
          font-family: "Roboto", sans-serif;
          font-size: 14px;
      }

      window {
          background-color: rgba(5, 16, 29, 0.88);
      }

      button {
          margin: 12px;
          color: #96b8bf;
          background-color: rgba(10, 20, 25, 0.85);
          border: 2px solid #1a8a8f;
          border-radius: 0;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
      }

      button:active,
      button:focus,
      button:hover {
          color: #05101d;
          background-color: rgba(45, 226, 230, 0.85);
          border-color: #2de2e6;
          outline-style: none;
      }

      /* destructive actions carry the alarm frame rather than a cyan glow */
      #shutdown,
      #reboot {
          color: #ff8080;
          border-color: #ff4d4d;
      }

      #shutdown:active,
      #shutdown:focus,
      #shutdown:hover,
      #reboot:active,
      #reboot:focus,
      #reboot:hover {
          color: #05101d;
          background-color: rgba(255, 77, 77, 0.9);
          border-color: #ff8080;
      }

      #lock {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }

      #logout {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }

      #suspend {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }

      #hibernate {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
      }

      #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }

      #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }
    '';
  };
}
