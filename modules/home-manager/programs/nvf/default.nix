{...}: {
  programs.nvf = {
    enable = true;
    enableManpages = true;
    settings.vim = {
      theme = {
        enable = true;
        name = "catppuccin";
        style = "macchiato";
        transparent = true;
      };

      statusline.lualine.enable = true;
      binds.whichKey.enable = true; # Menu / keybinding helper
      telescope.enable = true; # Fuzzy finder menu
      treesitter.enable = true;
      lsp.formatOnSave = true;

      # Languages with LSP + Treesitter
      languages = {
        ts.enable = true;
        ts.lsp.enable = true;
        ts.treesitter.enable = true;
        enableFormat = true;

        python.enable = true;
        python.lsp.enable = true;

        rust.enable = true;
        rust.lsp.enable = true;

        nix.enable = true;
      };

      autocomplete.blink-cmp.enable = true;

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false; # throws an annoying debug message
      };

      minimap = {
        minimap-vim.enable = false;
        codewindow.enable = true; # lighter, faster, and uses lua for configuration
      };
      dashboard = {
        dashboard-nvim.enable = false;
        alpha.enable = true;
      };

      notify = {
        nvim-notify.enable = true;
      };

      projects = {
        project-nvim.enable = true;
      };

      terminal = {
        toggleterm = {
          enable = true;
        };
      };
      assistant = {
        avante-nvim = {
          enable = true;
          setupOpts = {
            provider = "litellm";
            providers = {
              litellm = {
                endpoint = "http://192.168.68.220:4000";
                model = "gpt-5";
              };
            };
          };
        };
      };
      visuals = {
        nvim-cursorline.enable = true;
        fidget-nvim.enable = true;
        rainbow-delimiters.enable = false;
        indent-blankline.enable = true;
      };
    };
  };
}
