{...}: {
  programs.nvf = {
    enable = true;
    enableManpages = true;
    settings.vim = {
      theme = {
        enable = true;
        name = "catppuccin";
        style = "macchiato";
        transparent = false;
      };

      statusline = {
        lualine = {
          enable = true;
          theme = "catppuccin";
        };
      };

      spellcheck.enable = true;

      lsp = {
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        trouble.enable = true;
        nvim-docs-view.enable = true;
        otter-nvim.enable = true;
      };

      languages = {
        enableLSP = true;
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        nix.enable = true;
        markdown.enable = true;
        bash.enable = true;
        css.enable = true;
        html.enable = true;
        sql.enable = true;
        kotlin.enable = true;
        ts.enable = true;
        go.enable = true;
        lua.enable = true;
        python.enable = true;
        typst.enable = true;
        #csharp.enable = true;
      };

      autopairs.nvim-autopairs.enable = true;
      autocomplete.nvim-cmp.enable = true;

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      telescope.enable = true;

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
    };
  };
}
