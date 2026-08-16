{config, ...}: {
  # Zsh shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";
    #enableAutosuggestion = true;
    #syntaxHighLighting.enable = true;
    shellAliases = {
      ff = "fastfetch";

      # git
      gaa = "git add --all";
      gcam = "git commit --all --message";
      gcl = "git clone";
      gco = "git checkout";
      ggl = "git pull";
      ggp = "git push";

      ld = "lazydocker";
      lg = "lazygit";

      repo = "cd $HOME/Documents/repositories";
      temp = "cd $HOME/Downloads/temp";

      v = "nvim";
      vi = "nvim";
      vim = "nvim";

      ls = "eza --icons always"; # default view
      ll = "eza -bhl --icons --group-directories-first"; # long list
      la = "eza -abhl --icons --group-directories-first"; # all list
      lt = "eza --tree --level=2 --icons"; # tree

      z = "zoxide";
    };

    initContent = ''
      # Bitwarden CLI — auto-unlock on first use of the session
      bw() {
        if [ -z "$BW_SESSION" ]; then
          export BW_SESSION=$(command bw unlock --raw 2>/dev/null)
          if [ -z "$BW_SESSION" ]; then
            echo "bw: not logged in. Run 'bw login' first." >&2
            return 1
          fi
        fi
        command bw "$@"
      }

      # kubectl auto-complete
      # source <(kubectl completion zsh)

      # bindings
      bindkey -e
      bindkey '^H' backward-delete-word
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word

      # open commands in $EDITOR with C-e
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^v" edit-command-line
    '';
  };
}
