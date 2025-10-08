{ pkgs, lib }:
{
  treefmt = {
    programs.nixfmt.enable = true;
  };

  nvf = {
    vim.languages.nix = {
      enable = true;
      treesitter.enable = true;
      lsp.enable = true;
    };
  };

  packages = with pkgs; [
    nil
    nixfmt-rfc-style
  ];
}
