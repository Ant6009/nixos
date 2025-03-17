{
  outputs,
  userConfig,
  pkgs,
  ...
}: {
  imports = [
    ../programs/aerospace
    ../programs/alacritty
    ../programs/bat
    ../programs/btop
    ../programs/fzf
    ../programs/git
    ../programs/gpg
    ../programs/lazygit
    ../programs/obs-studio
    ../programs/starship
    ../programs/tmux
    ../programs/zsh
    ../scripts
  ];

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  # Home-Manager configuration for the user's home environment
  home = {
    username = "${userConfig.name}";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${userConfig.name}"
      else "/home/${userConfig.name}";
  };

  # Ensure common packages are installed
  home.packages = builtins.trace "Loading home.packages ..." (
    with pkgs;
      [
        dig
        du-dust
        eza
        fd
        jq
        nh
        zsh-vi-mode
        openconnect
        pipenv
        python3
        ripgrep
        firefox
        roam-research
        slack
        discord
        devenv
      ]
      ++ lib.optionals stdenv.isDarwin [
        colima
      ]
      ++ lib.optionals (!stdenv.isDarwin) [
        pavucontrol
        pulseaudio
        tesseract
        unzip
        wl-clipboard
        dunst
        wofi
        tofi
        grim
        slurp
        grimblast
        showmethekey
        tidal-hifi
        neofetch
        brave
      ]
  );

  # Catpuccin flavor and accent
  catppuccin = {
    flavor = "macchiato";
    accent = "lavender";
  };
}
