{...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock &";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session && brightnessctl -s set 10";
          on-resume = "notify-send \"Resuming\" && brightnessctl -r";
        }
        {
          timeout = 660;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        #{
        #timeout = 11000;
        #on-timeout = "systemctl suspend";
        #}
      ];
    };
  };
}
