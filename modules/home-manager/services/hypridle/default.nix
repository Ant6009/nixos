{pkgs, ...}: let
  # Hyprland 0.55+ parses `hyprctl dispatch` in the syntax of whichever config
  # format the *running* compositor loaded: `hl.dsp.*` under hyprland.lua, bare
  # dispatcher names under hyprland.conf. A session only switches format at
  # login, so probe it instead of trusting which file is on disk. The probe is
  # side-effect free, and scripts keep the Lua form out of hypridle.conf.
  hyprDpms = mode: pkgs.writeShellScriptBin "hypr-dpms-${mode}" ''
    if hyprctl dispatch "hl.dsp.no_op()" 2>&1 | grep -q "Invalid dispatcher"; then
      exec hyprctl dispatch dpms ${mode}
    fi
    exec hyprctl dispatch "hl.dsp.dpms({ action = '${mode}' })"
  '';
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock &";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "${hyprDpms "on"}/bin/hypr-dpms-on";
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session && brightnessctl -s set 10";
          on-resume = "notify-send \"Resuming\" && brightnessctl -r";
        }
        {
          timeout = 660;
          on-timeout = "${hyprDpms "off"}/bin/hypr-dpms-off";
          on-resume = "${hyprDpms "on"}/bin/hypr-dpms-on";
        }
        #{
        #timeout = 11000;
        #on-timeout = "systemctl suspend";
        #}
      ];
    };
  };
}
