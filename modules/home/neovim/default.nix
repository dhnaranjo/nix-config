{ flake, pkgs, ... }:
{
  imports = [
    flake.inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = import ./nixvim.nix { inherit pkgs; } // {
    enable = true;
    nixpkgs.config.allowUnfree = true;

    dependencies = {
      nodejs.enable = true;
      tree-sitter.enable = true;
      claude-code = {
        enable = true;
        package = pkgs.claude-code;
      };
      imagemagick.enable = true;
    };

  };

  home.packages = with pkgs; [
    # Snacks.image deps
    ghostscript
    mermaid-cli
  ];
}
