{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./programs
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "antoine";
  home.homeDirectory = "/home/antoine";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Desktop
    dunst
    wofi
    tofi
    swappy
    grim
    slurp
    grimblast
    showmethekey

    # Terminal
    alacritty
    fzf
    fzf-zsh
    eza
    ripgrep
    fd
    lazygit
    zoxide
    btop

    # Music & Sound
    pavucontrol
    hydrogen
    csound
    supercollider
    tidal-hifi
    reaper

    # Communication
    discord

    # Misc
    wl-clipboard
    roam-research
    zotero
    blueberry
    bitwarden-desktop
    bitwarden-cli
  ];

  programs = {
    git = {
      enable = true;
      userName = "ant6009";
      userEmail = "ant.rivoire@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
      };
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  services.dunst = {
    enable = true;
    #    global = {
    #      transparency = 10;
    #      frame_color = "#efefef";
    #    };
  };

  # Hyprland setup

  wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, F, exec, firefox"
          "$mod, A, exec, alacritty"
          ", Print, exec, grimblast copy area"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
  };
     
  fonts.fontconfig.enable = true;  

  programs.waybar.enable = true;
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you  don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/antoine/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
