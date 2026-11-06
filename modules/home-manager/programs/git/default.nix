{userConfig, ...}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    signing = {
      format = "openpgp";
      key = userConfig.gitKey;
      signByDefault = true;
    };
    settings = {
      user = {
        Name = "ant6009";
        Email = "ant.rivoire@gmail.com";
      };
      pull.rebase = "true";
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      keep-plus-minus-markers = true;
      light = false;
      line-numbers = true;
      navigate = true;
      width = 280;
      # Coldark-Cold matches the bat theme (programs/bat) and the ship palette,
      # replacing the catppuccin feature bundle the catppuccin module injected.
      dark = true;
      syntax-theme = "Coldark-Cold";
    };
  };
}
