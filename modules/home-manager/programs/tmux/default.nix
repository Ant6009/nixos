{ config, ... }:
let
  palette = import ../../theme/palette.nix;
in {
  # Tmux terminal multiplexer configuration
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 10;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    sensibleOnTop = false;
    terminal = "screen-256color";

    extraConfig = palette.substitute config.rocinante.palette ''
      # Set the prefix to `ctrl + q` instead of `ctrl + b`
      #set -g prefix C-q
      #unbind C-b
      set -g extended-keys on

      # Use | and - to split a window vertically and horizontally instead of " and % respoectively
      #unbind '"'
      #unbind %
      #bind v split-window -h -c "#{pane_current_path}"
      #bind s split-window -v -c "#{pane_current_path}"

      # Bind Arrow keys to resize the window
      bind -n S-Down resize-pane -D 8
      bind -n S-Up resize-pane -U 8
      bind -n S-Left resize-pane -L 8
      bind -n S-Right resize-pane -R 8

      # Rename window with prefix + r
      bind r command-prompt -I "#W" "rename-window '%%'"

      # Reload tmux config by pressing prefix + R
      bind R source-file ~/.config/tmux/tmux.conf \; display "TMUX Conf Reloaded"

      # Clear screen with prefix + l
      bind C-l send-keys 'C-l'

      # Open a project in a separate window
      bind-key -n C-f run-shell "tmux new-window -t 10 -n project-selector cd-to-project"

      # Apply Tc
      set -ga terminal-overrides ",xterm-256color:RGB:smcup@:rmcup@"

      # Enable focus-events
      set -g focus-events on

      # Set default escape-time
      set-option -sg escape-time 10

      set -g status-position top

      # Smart pane switching with awareness of Vim splits
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf|atuin)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R

      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      bind P paste-buffer
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"

      # ---- Rocinante / MCRN console styling ------------------------------
      # Replaces the Catppuccin tmux plugin: same top status bar idea, ship
      # palette, no rounded nothing. Colours need truecolor, which the
      # terminal-overrides RGB line above already enables.
      set -g status-style "bg=#0a1419,fg=#96b8bf"
      set -g status-interval 10
      set -g status-left-length 30
      set -g status-right-length 60
      set -g status-left "#[bg=#2de2e6,fg=#05101d,bold] #S "
      set -g status-right "#[fg=#5c8189]#H #[fg=#1a8a8f]| #[fg=#2de2e6]%H:%M #[fg=#96b8bf]%d %b"

      set -g window-status-current-style "bg=#2de2e6,fg=#05101d,bold"
      set -g window-status-current-format " #I:#W "
      set -g window-status-style "bg=#0a1419,fg=#5c8189"
      set -g window-status-format " #I:#W "
      set -g window-status-activity-style "bg=#0a1419,fg=#ffb454"
      set -g window-status-bell-style "bg=#ff4d4d,fg=#05101d"
      set -g window-status-separator ""

      set -g pane-border-style "fg=#12232c"
      set -g pane-active-border-style "fg=#1a8a8f"
      set -g message-style "bg=#2de2e6,fg=#05101d"
      set -g message-command-style "bg=#ffb454,fg=#05101d"
      set -g mode-style "bg=#1a8a8f,fg=#eafcff"
      set -g clock-mode-colour "#2de2e6"
      set -g clock-mode-style 24
      set -g display-panes-colour "#ffb454"
      set -g display-panes-active-colour "#2de2e6"
    '';
  };
}
