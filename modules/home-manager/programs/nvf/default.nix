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

      spellcheck = {
        enable = true;
        programmingWordlist.enable = false;
      };

      diagnostics = {
        enable = true;
        config = {
          virtual_text = true;
        };
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        lspkind.enable = true;
        lightbulb.enable = true;
        lspsaga.enable = true;
        trouble.enable = true;
        otter-nvim.enable = false;
        nvim-docs-view.enable = true;
        harper-ls.enable = true;
      };

      # Languages with LSP + Treesitter
      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        bash.enable = true;
        csharp.enable = true;

        css.enable = true;
        html.enable = true;
        json.enable = true;
        tailwind.enable = true;

        sql.enable = true;

        typst.enable = true;

        ts.enable = true;

        clojure.enable = true;

        python.enable = true;
        python.lsp.enable = true;

        rust.enable = true;
        rust.lsp.enable = true;

        nix.enable = true;
        csharp.treesitter.enable = true;
        csharp.lsp.enable = true;
        csharp.lsp.servers = ["roslyn_ls"];
      };

      autocomplete = {
        blink-cmp.enable = true;
      };

      repl.conjure.enable = true;

      autopairs.nvim-autopairs.enable = true;

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false; # throws an annoying debug message
      };

      minimap = {
        minimap-vim.enable = true;
        codewindow.enable = false; # lighter, faster, and uses lua for configuration
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
          lazygit.enable = true;
        };
      };

      ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
        breadcrumbs = {
          enable = true;
          navbuddy.enable = false;
        };
      };

      clipboard = {
        providers.wl-copy.enable = true;
        registers = "unnamedplus";
      };

      assistant = {
        avante-nvim = {
          enable = false;
          setupOpts = {
            provider = "litellm";
            providers = {
              litellm = {
                __inherited_from = "openai";
                endpoint = "http://192.168.68.220:4000/v1";
                model = "claude-sonnet-4-5-20250929";
                api_key_name = "LITELLM_API_KEY";
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
      utility = {
        snacks-nvim.enable = true;
        motion = {
          precognition.enable = false;
        };
        images = {
          img-clip.enable = true;
        };
      };
    };
  };
}
