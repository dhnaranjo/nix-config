# Neovim configuration managed using https://github.com/nix-community/nixvim
{ pkgs, ... }:
{
  # Meta
  vimAlias = true;
  enableMan = true;

  # Theme
  colorschemes.tokyonight.enable = true;

  # Settings
  opts = {
    expandtab = true;
    shiftwidth = 2;
    smartindent = true;
    tabstop = 2;
    number = true;
    clipboard = "unnamedplus";
  };

  # Keymaps
  globals = {
    mapleader = " ";
  };

  plugins = {
    # UI
    web-devicons.enable = true;
    lualine.enable = true;
    bufferline.enable = true;
    treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        css
        diff
        dockerfile
        git_config
        gitcommit
        gitignore
        gleam
        go
        graphql
        html
        ini
        javascript
        jq
        json
        just
        lua
        make
        markdown
        markdown_inline
        nix
        python
        regex
        ruby
        scss
        sql
        ssh_config
        swift
        terraform
        toml
        tsx
        typescript
        xml
        yaml
      ];
    };
    blink-cmp = {
      enable = true;
      settings = {
        completion = {
          documentation = {
            auto_show = true;
          };
        };
        signature = {
          enabled = true;
        };
      };
    };
    which-key.enable = true;
    noice = {
      enable = true;
      settings.presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        #inc_rename = false;
        #lsp_doc_border = false;
      };
    };
    snacks = {
      enable = true;
      settings = {
        notifier.enable = true;
        picker = {
          matcher = {
            frecency = true;
          };
        };
        terminal = {
          keys = {
            q = "hide";
          };
        };
        image = {
          math = false;
        };
      };
    };

    # Dev
    lsp = {
      enable = true;
      servers = {
        marksman.enable = true;
        nil_ls.enable = true;
        openscad_lsp = {
          enable = true;
        };
      };
    };
    lsp-format.enable = true;
    claude-code.enable = true;

  };
  keymaps = [
    # Open lazygit within nvim.
    {
      key = "<leader>gg";
      action = "<cmd>lua Snacks.lazygit()<CR>";
    }
    {
      key = "<leader><space>";
      action = "<cmd>lua Snacks.picker.smart()<CR>";
      options.desc = "Smart Find Files";
    }
    {
      key = "<leader>,";
      action = "<cmd>lua Snacks.picker.buffers()<CR>";
      options.desc = "Buffers";
    }
    {
      key = "<leader>/";
      action = "<cmd>lua Snacks.picker.grep()<CR>";
      options.desc = "Grep";
    }
    {
      key = "<leader>:";
      action = "<cmd>lua Snacks.picker.command_history()<CR>";
      options.desc = "Command History";
    }
    {
      key = "<leader>n";
      action = "<cmd>lua Snacks.picker.notifications()<CR>";
      options.desc = "Notification History";
    }
    {
      key = "<leader>e";
      action = "<cmd>lua Snacks.explorer()<CR>";
      options.desc = "File Explorer";
    }
    # find
    {
      key = "<leader>fb";
      action = "<cmd>lua Snacks.picker.buffers()<CR>";
      options.desc = "Buffers";
    }
    {
      key = "<leader>fc";
      action = "<cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath(\"config\") })<CR>";
      options.desc = "Find Config File";
    }
    {
      key = "<leader>ff";
      action = "<cmd>lua Snacks.picker.files()<CR>";
      options.desc = "Find Files";
    }
    {
      key = "<leader>fg";
      action = "<cmd>lua Snacks.picker.git_files()<CR>";
      options.desc = "Find Git Files";
    }
    {
      key = "<leader>fp";
      action = "<cmd>lua Snacks.picker.projects()<CR>";
      options.desc = "Projects";
    }
    {
      key = "<leader>fr";
      action = "<cmd>lua Snacks.picker.recent()<CR>";
      options.desc = "Recent";
    }

    # git
    {
      key = "<leader>gb";
      action = "<cmd>lua Snacks.picker.git_branches()<CR>";
      options.desc = "Git Branches";
    }
    {
      key = "<leader>gl";
      action = "<cmd>lua Snacks.picker.git_log()<CR>";
      options.desc = "Git Log";
    }
    {
      key = "<leader>gL";
      action = "<cmd>lua Snacks.picker.git_log_line()<CR>";
      options.desc = "Git Log Line";
    }
    {
      key = "<leader>gs";
      action = "<cmd>lua Snacks.picker.git_status()<CR>";
      options.desc = "Git Status";
    }
    {
      key = "<leader>gS";
      action = "<cmd>lua Snacks.picker.git_stash()<CR>";
      options.desc = "Git Stash";
    }
    {
      key = "<leader>gd";
      action = "<cmd>lua Snacks.picker.git_diff()<CR>";
      options.desc = "Git Diff (Hunks)";
    }
    {
      key = "<leader>gf";
      action = "<cmd>lua Snacks.picker.git_log_file()<CR>";
      options.desc = "Git Log File";
    }
    # Grep
    {
      key = "<leader>sb";
      action = "<cmd>lua Snacks.picker.lines()<CR>";
      options.desc = "Buffer Lines";
    }
    {
      key = "<leader>sB";
      action = "<cmd>lua Snacks.picker.grep_buffers()<CR>";
      options.desc = "Grep Open Buffers";
    }
    {
      key = "<leader>sg";
      action = "<cmd>lua Snacks.picker.grep()<CR>";
      options.desc = "Grep";
    }
    {
      key = "<leader>sw";
      action = "<cmd>lua Snacks.picker.grep_word()<CR>";
      mode = [
        "n"
        "x"
      ];
      options.desc = "Visual selection or word";
    }
    # search
    {
      key = "<leader>s\"";
      action = "<cmd>lua Snacks.picker.registers()<CR>";
      options.desc = "Registers";
    }
    {
      key = "<leader>s/";
      action = "<cmd>lua Snacks.picker.search_history()<CR>";
      options.desc = "Search History";
    }
    {
      key = "<leader>sa";
      action = "<cmd>lua Snacks.picker.autocmds()<CR>";
      options.desc = "Autocmds";
    }
    {
      key = "<leader>sb";
      action = "<cmd>lua Snacks.picker.lines()<CR>";
      options.desc = "Buffer Lines";
    }
    {
      key = "<leader>sc";
      action = "<cmd>lua Snacks.picker.command_history()<CR>";
      options.desc = "Command History";
    }
    {
      key = "<leader>sC";
      action = "<cmd>lua Snacks.picker.commands()<CR>";
      options.desc = "Commands";
    }
    {
      key = "<leader>sd";
      action = "<cmd>lua Snacks.picker.diagnostics()<CR>";
      options.desc = "Diagnostics";
    }
    {
      key = "<leader>sD";
      action = "<cmd>lua Snacks.picker.diagnostics_buffer()<CR>";
      options.desc = "Buffer Diagnostics";
    }
    {
      key = "<leader>sh";
      action = "<cmd>lua Snacks.picker.help()<CR>";
      options.desc = "Help Pages";
    }
    {
      key = "<leader>sH";
      action = "<cmd>lua Snacks.picker.highlights()<CR>";
      options.desc = "Highlights";
    }
    {
      key = "<leader>si";
      action = "<cmd>lua Snacks.picker.icons()<CR>";
      options.desc = "Icons";
    }
    {
      key = "<leader>sj";
      action = "<cmd>lua Snacks.picker.jumps()<CR>";
      options.desc = "Jumps";
    }
    {
      key = "<leader>sk";
      action = "<cmd>lua Snacks.picker.keymaps()<CR>";
      options.desc = "Keymaps";
    }
    {
      key = "<leader>sl";
      action = "<cmd>lua Snacks.picker.loclist()<CR>";
      options.desc = "Location List";
    }
    {
      key = "<leader>sm";
      action = "<cmd>lua Snacks.picker.marks()<CR>";
      options.desc = "Marks";
    }
    {
      key = "<leader>sM";
      action = "<cmd>lua Snacks.picker.man()<CR>";
      options.desc = "Man Pages";
    }
    {
      key = "<leader>sp";
      action = "<cmd>lua Snacks.picker.lazy()<CR>";
      options.desc = "Search for Plugin Spec";
    }
    {
      key = "<leader>sq";
      action = "<cmd>lua Snacks.picker.qflist()<CR>";
      options.desc = "Quickfix List";
    }
    {
      key = "<leader>sR";
      action = "<cmd>lua Snacks.picker.resume()<CR>";
      options.desc = "Resume";
    }
    {
      key = "<leader>su";
      action = "<cmd>lua Snacks.picker.undo()<CR>";
      options.desc = "Undo History";
    }
    {
      key = "<leader>uC";
      action = "<cmd>lua Snacks.picker.colorschemes()<CR>";
      options.desc = "Colorschemes";
    }
    # LSP
    {
      key = "gd";
      action = "<cmd>lua Snacks.picker.lsp_definitions()<CR>";
      options.desc = "Goto Definition";
    }
    {
      key = "gD";
      action = "<cmd>lua Snacks.picker.lsp_declarations()<CR>";
      options.desc = "Goto Declaration";
    }
    {
      key = "gr";
      action = "<cmd>lua Snacks.picker.lsp_references()<CR>";
      options = {
        desc = "References";
        nowait = true;
      };
    }
    {
      key = "gI";
      action = "<cmd>lua Snacks.picker.lsp_implementations()<CR>";
      options.desc = "Goto Implementation";
    }
    {
      key = "gy";
      action = "<cmd>lua Snacks.picker.lsp_type_definitions()<CR>";
      options.desc = "Goto T[y]pe Definition";
    }
    {
      key = "<leader>ss";
      action = "<cmd>lua Snacks.picker.lsp_symbols()<CR>";
      options.desc = "LSP Symbols";
    }
    {
      key = "<leader>sS";
      action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>";
      options.desc = "LSP Workspace Symbols";
    }
  ];
}
