{ config, pkgs, ... }:


{

  home.packages = with pkgs; [
    thefuck
    ];

    programs = {
        zsh = {
            enable = true;
            oh-my-zsh = {
                enable = true;
                theme = "refined";
                plugins = [
                    "git"
		    "thefuck"
                ];
            };
            autosuggestions.enable = true;
            enableCompletion = true;
            syntaxHighlighting.enable = true;
        };
    };

    shellAliases = {
      ll = "ls -l";
      vim = "nvim";
      update = "sudo nixos-rebuild switch";
    };

#    home.file.".zshrc".text = ''
#export PATH=$HOME/bin:/usr/local/bin:$PATH
## Path to your oh-my-zsh installation.
##export ZSH="$HOME/.oh-my-zsh"
#
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#
#
#ZSH_THEME="refined"
#REFINED_CHAR_SYMBOL="⚡"
#
## Rofi
#export PATH=$HOME/.config/rofi/scripts:$PATH
#export PATH=$PATH:~/Apps
#    '';
}
