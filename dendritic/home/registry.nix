{...}: let
  hm = ../../modules/home-manager;
in {
  # Exposes each legacy home-manager module rocinante uses today as
  # flake.homeModules.<name>. rocinante-dendritic consumes these by name
  # via host-specific profile lists in phase 4; for now it takes all of
  # them, matching the legacy import set exactly.
  #
  # Entries intentionally mirror the legacy rocinante module set
  # (modules/home-manager/common/default.nix imports +
  # home/antoine/rocinante/default.nix imports). Modules that exist on
  # disk but are not used by rocinante (bottom, dunst, rofi, wofi,
  # waybar, kanshi, gtk, xdg, etc.) are deliberately omitted and will
  # be added in later phases as other hosts opt in.
  flake.homeModules = {
    # programs
    aerospace = "${hm}/programs/aerospace";
    alacritty = "${hm}/programs/alacritty";
    bat = "${hm}/programs/bat";
    btop = "${hm}/programs/btop";
    claude-code = "${hm}/programs/claude-code";
    fzf = "${hm}/programs/fzf";
    git = "${hm}/programs/git";
    gpg = "${hm}/programs/gpg";
    lazygit = "${hm}/programs/lazygit";
    nvf = "${hm}/programs/nvf";
    obs-studio = "${hm}/programs/obs-studio";
    opencode = "${hm}/programs/opencode";
    starship = "${hm}/programs/starship";
    tmux = "${hm}/programs/tmux";
    zoom = "${hm}/programs/zoom";
    zsh = "${hm}/programs/zsh";

    # services
    easyeffects = "${hm}/services/easyeffects";
    hyprlock = "${hm}/services/hyprlock";
    hyprpaper = "${hm}/services/hyprpaper";
    ulauncher = "${hm}/services/ulauncher";

    # misc
    wallpaper = "${hm}/misc/wallpaper";

    # desktop
    hyprland = "${hm}/desktop/hyprland";

    # scripts bin
    scripts = "${hm}/scripts";

    # Core home config (username, homeDirectory, sessionVariables,
    # common packages, catppuccin). Replaces the body of the legacy
    # modules/home-manager/common/default.nix whose imports list is
    # now redundant with the entries above.
    core = {
      userConfig,
      pkgs,
      lib,
      ...
    }: {
      home = {
        username = "${userConfig.name}";
        homeDirectory =
          if pkgs.stdenv.isDarwin
          then "/Users/${userConfig.name}"
          else "/home/${userConfig.name}";
      };

      home.sessionVariables = {
        LITELLM_API_KEY = "sk-wAcBKCQ5Ef9zzF-KB-X6Gw";
      };

      home.packages = with pkgs;
        [
          dig
          dust
          eza
          fd
          jq
          nh
          gh
          zsh-vi-mode
          openconnect
          pipenv
          python3
          ripgrep
          slack
          discord
          devenv
          powershell
          typst
          go
        ]
        ++ lib.optionals stdenv.isDarwin [
          colima
        ]
        ++ lib.optionals (!stdenv.isDarwin) [
          pavucontrol
          pulseaudio
          tesseract
          wl-clipboard
          grim
          slurp
          grimblast
          showmethekey
          tidal-hifi
          fastfetch
          brave
        ];

      catppuccin = {
        flavor = "macchiato";
        accent = "lavender";
      };
    };
  };
}
