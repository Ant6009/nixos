{...}: let
  hm = ../../modules/home-manager;
in {
  # Baseline home-manager modules shared by every user on every host:
  # mirrors the legacy modules/home-manager/common/default.nix imports
  # list (minus the imports-management itself, which is now this file).
  #
  # Linux-desktop-only modules (hyprland, wallpaper, hyprpaper, hyprlock,
  # ulauncher, easyeffects, zoom) and Linux-only packages live outside
  # this baseline and are added to specific host configs directly, since
  # the darwin a.rivoire user must not pull them in.
  flake.homeModules = {
    # programs — baseline
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
    zsh = "${hm}/programs/zsh";

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
