# Neovim configuration managed using https://github.com/nix-community/nixvim
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
    treesitter.enable = true;
    which-key = {
      enable = true;
    };
    noice = {
      # WARNING: This is considered experimental feature, but provides nice UX
      enable = true;
      settings.presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        #inc_rename = false;
        #lsp_doc_border = false;
      };
    };
    telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = {
          options.desc = "file finder";
          action = "find_files";
        };
        "<leader>fg" = {
          options.desc = "find via grep";
          action = "live_grep";
        };
      };
      extensions = {
        file-browser.enable = true;
        manix.enable = true;
      };
    };

    # Dev
    lsp = {
      enable = true;
      servers = {
        hls = {
          enable = true;
          installGhc = false; # Managed by Nix devShell
        };
        marksman.enable = true;
        nil_ls.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
      };
    };
    lazygit.enable = true;
  };
  keymaps = [
    # Open lazygit within nvim. 
    {
      action = "<cmd>LazyGit<CR>";
      key = "<leader>gg";
    }
  ];

  dependencies = {
    manix.enable = true;
  };

  extraConfigLua = ''
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Wait for telescope to be available
        vim.schedule(function()
          local has_telescope, telescope = pcall(require, 'telescope')
          if not has_telescope then return end
          
          -- Load the extension first
          telescope.load_extension('manix')
          
          -- Now monkey-patch the search function
          local actions = require("telescope.actions")
          local actions_state = require("telescope.actions.state")
          
          -- Override the problematic attach_mappings
          local manix_mod = require("telescope-manix")
          local original_search = manix_mod.search
          
          manix_mod.search = function(opts)
            opts = opts or {}
            opts.attach_mappings = function(buf)
              actions.select_default:replace(function()
                local entry = actions_state.get_selected_entry()
                if entry and entry.display then
                  actions.close(buf)
                  -- Fix: ensure it's a valid string
                  local text = tostring(entry.display)
                  if text and text ~= "" then
                    vim.api.nvim_put({ text }, "", true, true)
                  else
                    vim.notify("Invalid manix entry", vim.log.levels.WARN)
                  end
                else
                  vim.notify("No entry selected", vim.log.levels.WARN)
                end
              end)
              return true
            end
            
            return original_search(opts)
          end
        end)
      end
    })
  '';
}
