{
  flake,
  pkgs,
  ...
}:
{
  imports = [
    flake.inputs.nvf.homeManagerModules.default
    ./languages/openscad.nix
  ];

  programs.nvf = import ./nvf.nix { inherit pkgs; } // {
    enable = true;
  };

  home.packages = with pkgs; [
    # Snacks.image deps
    ghostscript
    mermaid-cli
  ];
}
