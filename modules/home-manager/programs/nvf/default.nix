{...}: {
  programs.nvf = {
    enable = true;
    enableManpages = true;
    settings.vim = {
      # Catppuccin colorscheme plugin dropped: the ship palette is defined
      # inline below (luaConfigPost), which keeps neovim on the same colors as
      # alacritty, hyprland, waybar and ~/.pi/agent/themes/rocinante.json.
      # Background stays transparent so alacritty's bridge-night shows through.
      theme.enable = false;

      luaConfigPost = ''
        -- rocinante: MCRN console colourscheme --------------------------------
        local pal = {
          fg = '#dceef2',
          dim = '#96b8bf',
          mute = '#5c8189',
          panel = '#0a1419',
          line = '#12232c',
          cyan = '#2de2e6',
          cyan_dim = '#1a8a8f',
          green = '#4fd6a0',
          amber = '#ffb454',
          red = '#ff4d4d',
          blue = '#6fc0d8',
          salmon = '#f5b0ab',
        }
        local function hl(group, opts)
          vim.api.nvim_set_hl(0, group, opts)
        end

        vim.cmd('highlight clear')
        vim.g.colors_name = 'rocinante'

        -- ground
        hl('Normal', { fg = pal.fg })
        hl('NormalFloat', { fg = pal.fg, bg = pal.panel })
        hl('Visual', { bg = pal.line })
        hl('MatchParen', { fg = pal.panel, bg = pal.amber, bold = true })
        hl('CursorLine', { bg = pal.panel })
        hl('CursorColumn', { bg = pal.panel })
        hl('ColorColumn', { bg = pal.line })
        hl('NonText', { fg = pal.mute })
        hl('EndOfLine', { fg = pal.line })
        hl('Whitespace', { fg = pal.line })

        -- chrome
        hl('LineNr', { fg = pal.mute })
        hl('CursorLineNr', { fg = pal.cyan, bold = true })
        hl('SignColumn', { fg = pal.mute })
        hl('VertSplit', { fg = pal.cyan_dim })
        hl('WinSeparator', { fg = pal.cyan_dim })
        hl('StatusLine', { fg = pal.fg, bg = pal.panel })
        hl('StatusLineNC', { fg = pal.mute, bg = pal.panel })
        hl('TabLine', { fg = pal.mute, bg = pal.panel })
        hl('TabLineSel', { fg = pal.panel, bg = pal.cyan, bold = true })
        hl('TabLineFill', { bg = pal.panel })
        hl('Pmenu', { fg = pal.fg, bg = pal.panel })
        hl('PmenuSel', { fg = pal.panel, bg = pal.cyan })
        hl('PmenuSbar', { bg = pal.line })
        hl('PmenuThumb', { bg = pal.cyan_dim })
        hl('Folded', { fg = pal.cyan_dim, bg = pal.panel, italic = true })
        hl('FoldColumn', { fg = pal.mute, bg = pal.panel })
        hl('WinBar', { fg = pal.dim, bold = true })
        hl('WildMenu', { fg = pal.panel, bg = pal.cyan })

        -- syntax
        hl('Comment', { fg = pal.dim, italic = true })
        hl('Todo', { fg = pal.amber, bold = true })
        hl('Constant', { fg = pal.salmon })
        hl('String', { fg = pal.green })
        hl('Character', { fg = pal.green })
        hl('Number', { fg = pal.amber })
        hl('Boolean', { fg = pal.amber })
        hl('Float', { fg = pal.amber })
        hl('Identifier', { fg = pal.blue })
        hl('Function', { fg = pal.cyan, bold = true })
        hl('Include', { fg = pal.cyan_dim })
        hl('Define', { fg = pal.cyan_dim })
        hl('PreProc', { fg = pal.cyan_dim })
        hl('Macro', { fg = pal.cyan_dim })
        hl('Keyword', { fg = pal.cyan })
        hl('Statement', { fg = pal.amber })
        hl('Conditional', { fg = pal.amber })
        hl('Repeat', { fg = pal.amber })
        hl('Operator', { fg = pal.dim })
        hl('Delimiter', { fg = pal.dim })
        hl('Exception', { fg = pal.red })
        hl('Type', { fg = pal.green })
        hl('StorageClass', { fg = pal.green })
        hl('Structure', { fg = pal.green })
        hl('Typedef', { fg = pal.green })
        hl('Special', { fg = pal.salmon })
        hl('SpecialChar', { fg = pal.salmon })
        hl('Tag', { fg = pal.blue })
        hl('Debug', { fg = pal.red })
        hl('Label', { fg = pal.cyan_dim })
        hl('Underlined', { fg = pal.blue, underline = true })
        hl('Error', { fg = pal.red, bold = true })

        -- search, diffs, diagnostics
        hl('Search', { fg = pal.panel, bg = pal.amber })
        hl('IncSearch', { fg = pal.panel, bg = pal.cyan })
        hl('Substitute', { fg = pal.panel, bg = pal.amber })
        hl('DiffAdd', { fg = pal.green, bg = pal.panel })
        hl('DiffChange', { fg = pal.blue, bg = pal.panel })
        hl('DiffDelete', { fg = pal.red, bg = pal.panel })
        hl('DiffText', { fg = pal.amber, bg = pal.panel })
        hl('DiagnosticError', { fg = pal.red })
        hl('DiagnosticWarn', { fg = pal.amber })
        hl('DiagnosticInfo', { fg = pal.blue })
        hl('DiagnosticHint', { fg = pal.cyan_dim })
        hl('DiagnosticUnderlineError', { fg = pal.red, undercurl = true })
        hl('DiagnosticUnderlineWarn', { fg = pal.amber, undercurl = true })
        hl('DiagnosticUnderlineInfo', { fg = pal.blue, undercurl = true })
        hl('DiagnosticUnderlineHint', { fg = pal.cyan_dim, undercurl = true })
        hl('LspReferenceText', { bg = pal.line })
        hl('LspReferenceRead', { bg = pal.line })
        hl('LspReferenceWrite', { bg = pal.line })

        -- picker / completion (telescope, blink, cmp)
        hl('TelescopeNormal', { fg = pal.fg, bg = pal.panel })
        hl('TelescopeBorder', { fg = pal.cyan_dim })
        hl('TelescopeSelection', { fg = pal.panel, bg = pal.cyan })
        hl('TelescopeSelectionCaret', { fg = pal.amber })
        hl('TelescopeMatching', { fg = pal.amber, bold = true })
        hl('TelescopePromptPrefix', { fg = pal.cyan })

        -- terminal inside neovim
        hl('Terminal', { fg = pal.fg, bg = pal.panel })
      '';

      opts = {
        tabstop = 4;
        shiftwidth = 4;
        expandtab = true;
        smartindent = true;
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
        lspsaga.enable = false;
        trouble.enable = true;
        otter-nvim.enable = false;
        nvim-docs-view.enable = true;
        presets = {
          tailwindcss-language-server.enable = true;
          harper.enable = true;
          # typescript-go disabled: crashes with "vfs: path is not absolute" and
          # "ScriptKind must be specified" panics (upstream bugs in tsgo)
          typescript-go.enable = false;
        };
      };

      # Languages with LSP + Treesitter
      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        bash.enable = true;

        css.enable = true;
        html.enable = true;
        json.enable = true;

        sql.enable = true;

        typst.enable = true;

        typescript = {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
        };

        markdown.enable = true;
        markdown.extensions.markview-nvim.enable = true;

        clojure.enable = true;

        python.enable = true;
        python.lsp.enable = true;

        rust.enable = true;
        rust.lsp.enable = true;

        nix.enable = true;

        csharp = {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
          lsp.servers = ["roslyn-ls"];
        };
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

      navigation = {
        harpoon.enable = true;
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
