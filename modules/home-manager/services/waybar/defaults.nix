{...}: {

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = 

{
     "layer" = "top";
    "position" = "top";
    "height" = 20;
    "margin-top"= 5;
    "margin-bottom"= 2;
    "margin-left"= 12;
    "margin-right" = 12;

    "reload_style_on_change" = true;

    "modules-center" = ["hyprland/workspaces"]; 

    "modules-left" = [
      "custom/power"
      "tray"
      ];
    
    "modules-right" = [
      "wireplumber"
      "bluetooth"
      "idle_inhibitor"
      "network"
      "clock"
      ];



     ];
          format-time = "{H}h {M}min";
          tooltip = true;
          tooltip-format = "{timeTo} {power}w";
        };

        bluetooth = {
          format = "";
          format-connected = " {num_connections}";
          tooltip-format = " {device_alias}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "Name: {device_alias}\nBattery: {device_battery_percentage}%";
          on-click = "blueman-manager";
        };

        clock = {
          format = "{:%b %d %H:%M}";
          format-alt = " {:%H:%M   %Y, %d %B, %A}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        cpu = {
          format = "󰍛 {usage}%";
          interval = 1;
        };

        "hyprland/language" = {
          format = "{short}";
        };

        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{name}";
          on-click = "activate";
          show-special = false;
          sort-by-number = true;
        };

        memory = {
          interval = 10;
          format = "󰾆 {used:0.1f}G";
          format-alt = "󰾆 {percentage}%";
          format-alt-click = "click";
          tooltip = true;
          tooltip-format = "{used:0.1f}GB/{total:0.1f}G";
          on-click-right = "foot --title btop sh -c 'btop'";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            default = [
              ""
              ""
              " "
            ];
          };
          on-click = "pavucontrol";
          on-scroll-up = "pamixer -i 5";
          on-scroll-down = "pamixer -d 5";
          scroll-step = 5;
          on-click-right = "pamixer -t";
          smooth-scrolling-threshold = 1;
          ignored-sinks = ["Easy Effects Sink"];
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          on-click = "pavucontrol";
          on-click-right = "pamixer --default-source -t";
          on-scroll-up = "pamixer --default-source -i 5";
          on-scroll-down = "pamixer --default-source -d 5";
        };

        temperature = {
          interval = 10;
          tooltip = false;
          hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
          critical-threshold = 82;
          format-critical = "{icon} {temperatureC}°C";
          format = "󰈸 {temperatureC}°C";
        };

        tray = {
          spacing = 20;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "custom/recorder" = {
          format = "";
          tooltip = false;
          return-type = "json";
          exec = "echo '{\"class\": \"recording\"}'";
          exec-if = "pgrep wf-recorder";
          interval = 1;
          on-click = "screen-recorder";
        };
      };
    };










style = ''
* {
@keyframes blink-warning {
  70% {
    color: @light;
  }

  to {
    color: @light;
    background-color: @warning;
  }
}

@keyframes blink-critical {
  70% {
    color: @light;
  }

  to {
    color: @light;
    background-color: @critical;
  }
}

/* -----------------------------------------------------------------------------
 * Styles
 * -------------------------------------------------------------------------- */

/* COLORS */

/* Nord */
@define-color bg #24273a;
/*@define-color bg #353C4A;*/
@define-color light #D8DEE9;
/*@define-color dark @nord_dark_font;*/
@define-color warning #ebcb8b;
@define-color critical #ed8706;
@define-color mode #434C5E;
/*@define-color workspaces @bg;*/
/*@define-color workspaces @nord_dark_font;*/
/*@define-color workspacesfocused #434C5E;*/
@define-color workspacesfocused #7dc4e4;
@define-color tray @workspacesfocused;
@define-color sound #EBCB8B;
@define-color network #5D7002;
@define-color memory #546484;
@define-color cpu #596A8D;
@define-color temp #4D5C78;
@define-color layout #5e81ac;
@define-color battery #88c0d0;
@define-color date #434C5E;
@define-color time #ee99a0;
@define-color backlight #434C5E;
@define-color nord_bg #24273a;
@define-color nord_bg_blue #546484;
@define-color nord_light #D8DEE9;
@define-color nord_light_font #D8DEE9;
@define-color nord_dark_font #434C5E;

@define-color c-bg #24273a;
@define-color c-bg_dark #181926;
@define-color c-text #cad3f5;
@define-color c-blue #8aadf4;
@define-color c-sky #91d7e3;
@define-color c-green #a6da95;
@define-color c-peach #f5a97f;
@define-color c-red #ed8796;
@define-color c-pink #f5bde6;
@define-color c-text_dark #181926;
@define-color c-overlay1 #6e738d;

/* Reset all styles */
* {
  border: none;
  border-radius: 3px;
  min-height: 0;
  margin: 0rem 0.3rem 0rem 0.3rem;
  padding: 0;
}

/* The whole bar */
#waybar {
  background-color: rgba (8, 8, 8, 0);
  color: white;
  font-family: "Cantarell", "Font Awesome 5 Pro";
  font-size: 0.7em;
  min-height: 0;
  font-weight: bold;
  opacity: 1;
}
.modules-center {
  background-color: @c-overlay1;
  opacity: 0.8;
  border-radius: 3px;
  padding: 1px 4px 1px 4px;
}
.modules-right {
  background-color: @c-overlay1;
  opacity: 0.8;
  border-radius: 3px;
  padding: 1px 10px 1px 10px;
}

.modules-left {
  background-color: @c-overlay1;
  opacity: 0.8;
  border-radius: 3px;
  padding: 1px 10px 1px 10px;
}
/* Each module */
#battery,
#clock,
#cpu,
#custom-layout,
#memory,
#mode,
#network,
#pulseaudio,
#temperature,
#custom-alsa,
#custom-pacman,
#custom-weather,
#custom-gpu,
#tray,
#backlight,
#language,
#custom-cpugovernor {
  padding-left: 0.3rem;
  padding-right: 0.3rem;
  padding-top: 0em;
}

/* Each module that should blink */
#mode,
#memory,
#temperature,
#battery {
  animation-timing-function: linear;
  animation-iteration-count: infinite;
  animation-direction: alternate;
}

/* Each critical module */
#memory.critical,
#cpu.critical,
#temperature.critical,
#battery.critical {
  color: @critical;
}

/* Each critical that should blink */
#mode,
#memory.critical,
#temperature.critical,
#battery.critical.discharging {
  animation-name: blink-critical;
  animation-duration: 2s;
}

/* Each warning */
#network.disconnected,
#memory.warning,
#cpu.warning,
#temperature.warning,
#battery.warning {
  background: @c-red;
  color: @c-text_dark;
}

/* Each warning that should blink */
#battery.warning.discharging {
  animation-name: blink-warning;
  animation-duration: 3s;
}

/* And now modules themselves in their respective order */

#mode {
  /* Shown current Sway mode (resize etc.) */
  color: @light;
  background: @mode;
}

/* Workspaces stuff */

#workspaces {
  /*color: @c-text;*/
  padding: 0.03em;
  margin: 0.03em 0.3em;
}

#workspaces button {
  font-weight: bold; /* Somewhy the bar-wide setting is ignored*/
  color: @c-text;
  opacity: 1;
  padding: 0;
  /*background: @c-blue;*/
}

#workspaces button.urgent {
  border-color: #c9545d;
  color: #c9545d;
  opacity: 1;
}

#workspaces button.active {
  background-color: white;
  color: @c-text_dark;
  padding: 0 0.3rem;
  opacity: 1;
}

#window {
  /*  margin-right: 40px;
  margin-left: 40px;
  font-weight: normal;*/
  padding: 0.03em;
  margin: 0.6em 0.3em;
}
#bluetooth {
  /*background: @c-blue;
  color: @c-bg;*/
  font-size: 1em;
  font-weight: bold;
}
#custom-gpu {
  background: @c-blue;
  font-weight: bold;
  padding: 0 0.2em 0 0.2em;
}
#custom-weather {
  background: @mode;
  font-weight: bold;
  padding: 0 0.2em;
}
#custom-pacman {
  background: @nord_light;
  color: @nord_dark_font;
  font-weight: bold;
  padding: 0 0.2em;
}
#custom-scratchpad-indicator {
  background: @nord_light;
  color: @nord_dark_font;
  font-weight: bold;
  padding: 0 0.2em;
}
#idle_inhibitor {
  /*background: @c-green;
  font-size: 1.6em;*/
  font-weight: bold;
  /*padding: 0 0.3em;
  margin: 0.3em 0.3em;*/
}
#custom-alsa {
  background: @sound;
}

#network {
  /*background: @c-green;
  margin: 0.3em 0.3em;*/
}

#memory {
  background: @c-pink;
}

#cpu {
  background: @c-pink;
  color: @c-text_dark;
}
#cpu.critical {
  color: @c-red;
}
#language {
  background: @nord_bg_blue;
  color: #d8dee9;
  padding: 0 0.2em;
}
#custom-cpugovernor {
  background-color: @nord_light;
  color: @nord_dark_font;
}
#custom-cpugovernor.perf {
}
#temperature {
  background-color: @nord_bg;
  color: #d8dee9;
}
#temperature.critical {
  background: @critical;
}
#custom-layout {
  background: @layout;
}

#battery {
  background: @battery;
}

#backlight {
  background: @backlight;
}

#clock {
  /*background: @c-pink;
  color: @c-text_dark;
  margin: 0.3em 0.3em;*/
}
#clock.date {
  background: @date;
}

#clock.time {
  /*background: @mode;
  color: @c-text_dark;
  margin: 0.3em 0.3em;*/
}

#pulseaudio {
  /* Unsused but kept for those who needs it */
  background: @nord_bg_blue;
  color: #d8dee9;
}

#pulseaudio.muted {
  background: #bf616a;
  color: #bf616a;
  /* No styles */
}
#pulseaudio.source-muted {
  background: #d08770;
  color: #d8dee9;
  /* No styles */
}
#tray {
  background: white;
  padding: 0.3em 0.3em;
  margin: 0.3em;
}
}
'';
}

