{
  outputs,
  userConfig,
  pkgs,
  ...
}: {
  imports = [
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
    ../programs/dunst
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
  home.packages = with pkgs;
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
      brave
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
      wlogout
    ];

  # Catpuccin flavor and accent
  catppuccin = {
    flavor = "macchiato";
    accent = "lavender";
  };
}
