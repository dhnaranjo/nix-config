{ pkgs, ... }:
let
  tree-sitter-openscad = pkgs.tree-sitter.buildGrammar {
    language = "openscad";
    version = "0.6.1";
    src = pkgs.fetchFromGitHub {
      owner = "openscad";
      repo = "tree-sitter-openscad";
      rev = "d3a17a97e1988a4f756dbb480a4c31d26d2a5d3d";
      hash = "sha256-R340VUUQioYJUEyCAeLNlNVkPX/4J7ylTOoJeRBLZZA=";
    };
    meta.homepage = "https://github.com/openscad/tree-sitter-openscad";
  };

  openscad-nvim = pkgs.vimPlugins.openscad-nvim.overrideAttrs {
    version = "2025-09-27";
    src = pkgs.fetchFromGitHub {
      owner = "salkin-mada";
      repo = "openscad.nvim";
      rev = "e81d938252fde30fbbe156bfc544bf2d9758272a";
      hash = "sha256-K0TKik9+YNlcxwhIxL+Azb8i+r9ULBzSIjZx2TqeSzM=";
    };
    doCheck = false;
  };
in
{
  home.packages = with pkgs; [
    openscad-unstable
  ];

  programs.nixvim = {
    plugins = {
      openscad = {
        enable = true;
        package = openscad-nvim;
        fuzzyFinderPlugin = null;
        settings = {
          pdf_command = "open";
          load_snippets = false;

          help_trig_key = "<A-h>";
          cheatsheet_toggle_key = "<Enter>";
          exec_openscad_trig_key = "<A-o>";
        };
      };

      treesitter = {
        enable = true;
        grammarPackages = [
          tree-sitter-openscad
        ];
      };
      lsp.servers.openscad_lsp = {
        enable = true;
      };
    };
    extraConfigLua = ''
      vim.g.openscad_fuzzy_finder = 'snacks'
    '';
  };
}
