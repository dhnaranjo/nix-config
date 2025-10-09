{ pkgs, lib }:
{
  treefmt = {
    programs.ruff.enable = true;
    programs.ruff-format.enable = true;
  };

  nvf = {
    vim.languages.python = {
      enable = true;
      treesitter.enable = true;
      lsp.enable = true;
    };
  };

  packages = with pkgs; [
    python3
    ruff
    pyright
  ];
}
