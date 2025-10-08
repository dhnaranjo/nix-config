{ config, pkgs, ... }:
let
  ghostty-darwin = pkgs.callPackage ../../pkgs/darwin/ghostty.nix {
    version = "1.2.2";
    hash = "sha256-gSuOOWZUzKKihCGmqEnieJJ8iP4xFeoSQIL536ka454=";
  };
in
{
  home-manager.users.dazmin = {
    home.packages = [
      ghostty-darwin
    ];

    programs = {
      ghostty.package = ghostty-darwin;

      bat.syntaxes = {
        ghostty = {
          src = ghostty-darwin;
          file = "share/bat/syntaxes/ghostty.sublime-syntax";
        };
      };
    };
  };
}
