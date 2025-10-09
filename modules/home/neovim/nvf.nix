{ pkgs, ... }:
{
  vim = {
    viAlias = false;
    vimAlias = true;

    theme = {
      enable = true;
      name = "tokyonight";
      style = "moon";
    };

    globals.mapleader = " ";

    luaConfigRC.ui-select = "vim.ui.select = Snacks.picker.select";

    options = {
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      number = true;
      clipboard = "unnamedplus";
    };

    visuals.nvim-web-devicons.enable = true;

    statusline.lualine.enable = true;

    tabline.nvimBufferline.enable = true;

    languages = {
      enableTreesitter = true;
      nix.enable = true;
    };
    lsp = {
      enable = true;
      formatOnSave = true;
    };
    treesitter.enable = true;

    autocomplete.blink-cmp = {
      enable = true;
      setupOpts = {
        completion.documentation.auto_show = true;
        signature.enabled = true;
      };
    };

    binds.whichKey.enable = true;

    # Editor enhancements (mini.nvim plugins)
    mini = {
      comment.enable = true;
      hipatterns.enable = true;
      pairs.enable = true;
      sessions.enable = true;
      snippets.enable = true;
      surround.enable = true;
    };

    ui.noice = {
      enable = true;
      setupOpts.presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
      };
    };

    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        bigfile.enable = true;
        explorer.enable = true;
        image = {
          enable = true;
          math = false;
        };
        notifier.enable = true;
        picker = {
          matcher = {
            frecency = true;
          };
        };
        quickfile.enable = true;
        terminal = {
          keys = {
            q = "hide";
          };
        };

        # Indent guides and scope visualization
        indent = {
          enable = true;
          char = "│";
          only_scope = false;
          only_current = false;
          animate = {
            enabled = true;
            style = "out";
            easing = "linear";
            duration = {
              step = 20;
              total = 500;
            };
          };
        };

        # LSP reference highlighting with navigation
        words = {
          enable = true;
          debounce = 200;
          notify_jump = false;
          notify_end = true;
          foldopen = true;
          jumplist = true;
          modes = [
            "n"
            "i"
            "c"
          ];
        };

        # Smooth scrolling
        scroll = {
          enable = true;
          animate = {
            duration = {
              step = 15;
              total = 250;
            };
            easing = "linear";
          };
        };
      };
    };

    keymaps =
      let
        mkLuaKeymap =
          desc: key: fn:
          {
            mode ? "n",
          }:
          {
            inherit key desc mode;
            action = "<cmd>lua ${fn}<CR>";
          };
      in
      [
        # Core Navigation
        (mkLuaKeymap "Smart Find Files" "<leader><space>" "Snacks.picker.smart()" { })
        (mkLuaKeymap "File Explorer" "<leader>e" "Snacks.explorer()" { })
        (mkLuaKeymap "Buffers" "<leader>," "Snacks.picker.buffers()" { })
        (mkLuaKeymap "Grep" "<leader>/" "Snacks.picker.grep()" { })

        # LSP
        (mkLuaKeymap "Goto Definition" "gd" "Snacks.picker.lsp_definitions()" { })
        (mkLuaKeymap "References" "gr" "Snacks.picker.lsp_references()" { })
        (mkLuaKeymap "Goto Implementation" "gI" "Snacks.picker.lsp_implementations()" { })
        (mkLuaKeymap "Goto T[y]pe Definition" "gy" "Snacks.picker.lsp_type_definitions()" { })
        (mkLuaKeymap "Goto Declaration" "gD" "Snacks.picker.lsp_declarations()" { })

        # Files
        (mkLuaKeymap "Find Files" "<leader>ff" "Snacks.picker.files()" { })
        (mkLuaKeymap "Recent" "<leader>fr" "Snacks.picker.recent()" { })
        (mkLuaKeymap "Buffers" "<leader>fb" "Snacks.picker.buffers()" { })
        (mkLuaKeymap "Find Git Files" "<leader>fg" "Snacks.picker.git_files()" { })
        (mkLuaKeymap "Projects" "<leader>fp" "Snacks.picker.projects()" { })
        (mkLuaKeymap "Find Config File" "<leader>fc"
          ''Snacks.picker.files({ cwd = vim.fn.stdpath("config") })''
          { }
        )

        # Git
        (mkLuaKeymap "lazygit" "<leader>gg" "Snacks.lazygit()" { })
        (mkLuaKeymap "Git Status" "<leader>gs" "Snacks.picker.git_status()" { })
        (mkLuaKeymap "Git Branches" "<leader>gb" "Snacks.picker.git_branches()" { })
        (mkLuaKeymap "Git Log" "<leader>gl" "Snacks.picker.git_log()" { })
        (mkLuaKeymap "Git Diff (Hunks)" "<leader>gd" "Snacks.picker.git_diff()" { })
        (mkLuaKeymap "Git Log File" "<leader>gf" "Snacks.picker.git_log_file()" { })
        (mkLuaKeymap "Git Log Line" "<leader>gL" "Snacks.picker.git_log_line()" { })
        (mkLuaKeymap "Git Stash" "<leader>gS" "Snacks.picker.git_stash()" { })

        # Search
        (mkLuaKeymap "Grep" "<leader>sg" "Snacks.picker.grep()" { })
        (mkLuaKeymap "Visual selection or word" "<leader>sw" "Snacks.picker.grep_word()" {
          mode = [
            "n"
            "x"
          ];
        })
        (mkLuaKeymap "Buffer Lines" "<leader>sb" "Snacks.picker.lines()" { })
        (mkLuaKeymap "Grep Open Buffers" "<leader>sB" "Snacks.picker.grep_buffers()" { })
        (mkLuaKeymap "Diagnostics" "<leader>sd" "Snacks.picker.diagnostics()" { })
        (mkLuaKeymap "Buffer Diagnostics" "<leader>sD" "Snacks.picker.diagnostics_buffer()" { })
        (mkLuaKeymap "LSP Symbols" "<leader>ss" "Snacks.picker.lsp_symbols()" { })
        (mkLuaKeymap "LSP Workspace Symbols" "<leader>sS" "Snacks.picker.lsp_workspace_symbols()" { })
        (mkLuaKeymap "Resume" "<leader>sR" "Snacks.picker.resume()" { })
        (mkLuaKeymap "Keymaps" "<leader>sk" "Snacks.picker.keymaps()" { })
        (mkLuaKeymap "Help Pages" "<leader>sh" "Snacks.picker.help()" { })
        (mkLuaKeymap "Commands" "<leader>sC" "Snacks.picker.commands()" { })
        (mkLuaKeymap "Command History" "<leader>sc" "Snacks.picker.command_history()" { })
        (mkLuaKeymap "Search History" "<leader>s/" "Snacks.picker.search_history()" { })
        (mkLuaKeymap "Marks" "<leader>sm" "Snacks.picker.marks()" { })
        (mkLuaKeymap "Jumps" "<leader>sj" "Snacks.picker.jumps()" { })
        (mkLuaKeymap "Registers" ''<leader>s"'' "Snacks.picker.registers()" { })
        (mkLuaKeymap "Quickfix List" "<leader>sq" "Snacks.picker.qflist()" { })
        (mkLuaKeymap "Location List" "<leader>sl" "Snacks.picker.loclist()" { })
        (mkLuaKeymap "Undo History" "<leader>su" "Snacks.picker.undo()" { })
        (mkLuaKeymap "Man Pages" "<leader>sM" "Snacks.picker.man()" { })
        (mkLuaKeymap "Highlights" "<leader>sH" "Snacks.picker.highlights()" { })
        (mkLuaKeymap "Icons" "<leader>si" "Snacks.picker.icons()" { })
        (mkLuaKeymap "Autocmds" "<leader>sa" "Snacks.picker.autocmds()" { })
        (mkLuaKeymap "Search for Plugin Spec" "<leader>sp" "Snacks.picker.lazy()" { })

        # UI
        (mkLuaKeymap "Notification History" "<leader>n" "Snacks.picker.notifications()" { })
        (mkLuaKeymap "Command History" "<leader>:" "Snacks.picker.command_history()" { })
        (mkLuaKeymap "Colorschemes" "<leader>uC" "Snacks.picker.colorschemes()" { })
      ];

    extraPackages = [ pkgs.imagemagick ];
  };
}
