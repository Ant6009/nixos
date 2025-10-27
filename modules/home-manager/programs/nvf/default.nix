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
        binds.whichKey.enable = true;   # Menu / keybinding helper
        telescope.enable = true;  # Fuzzy finder menu
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
      #autocomplete.nvim-cmp.enable = true;
       #       enable = true;
       #       formatOnSave = true;
       #       lspkind.enable = false;
       #       lightbulb.enable = true;
       #       trouble.enable = true;
       #       nvim-docs-view.enable = true;
       #       otter-nvim.enable = true;
       #     };
       #
      ##     languages = {
      ##       enableFormat = true;
      ##       enableTreesitter = true;
      #       enableExtraDiagnostics = true;
      #       nix.enable = true;
      #       markdown.enable = true;
      #       bash.enable = true;
      #       css.enable = true;
      #       html.enable = true;
      #       sql.enable = true;
      #       kotlin.enable = true;
      #       ts.enable = true;
      #       go.enable = true;
      #       lua.enable = true;
      #       python.enable = true;
      #       #        typst.enable = true;
      #       #csharp.enable = true;
      #     };

      #     autopairs.nvim-autopairs.enable = true;
      #     autocomplete.nvim-cmp.enable = true;

      #     binds = {
      #       whichKey.enable = true;
      #       cheatsheet.enable = true;
      #     };


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

<<<<<<< HEAD
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
=======
           visuals = {
             nvim-cursorline.enable = true;
             fidget-nvim.enable = true;
             rainbow-delimiters.enable = false;
             indent-blankline.enable = true;
           };

           terminal = {
             toggleterm = {
               enable = true;
             };
           };
>>>>>>> 210760af324e316bc0617696205cf77af38f813d
    };
    };
    }

