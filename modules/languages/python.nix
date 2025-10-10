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
      lsp = {
        enable = true;
        # TODO (2025-10-16): Revert to basedpyright once fix propagates to nixos-unstable
        # https://github.com/NixOS/nixpkgs/pull/450202
        server = "pyright";
      };
    };
  };

  packages = with pkgs; [
    python3
    ruff
    pyright
  ];
}
