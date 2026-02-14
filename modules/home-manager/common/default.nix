{
  userConfig,
  pkgs,
  lib,
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
    ../programs/nvf
    ../programs/claude-code
    ../scripts
  ];

  # Home-Manager configuration for the user's home environment
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

  # Ensure common packages are installed
  home.packages = with pkgs;
    [
      dig
      dust
      eza
      fd
      jq
      nh
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

  # Catpuccin flavor and accent
  catppuccin = {
    flavor = "macchiato";
    accent = "lavender";
  };
}
