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
in
{
  programs.nvf.settings.vim = {
    treesitter.grammars = [ tree-sitter-openscad ];

    lsp.lspconfig.sources.openscad-lsp = ''
      lspconfig.openscad_lsp.setup {
        capabilities = capabilities,
        on_attach = default_on_attach,
        cmd = { "${pkgs.openscad-lsp}/bin/openscad-lsp", "--stdio" }
      }
    '';
  };
}
