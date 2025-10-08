{
  pkgs,
  lib,
  neovimPackage,
  ...
}:
let
  langs = import ../../languages { inherit pkgs lib; };
in
{
  home.packages = [
    neovimPackage
  ]
  ++ langs.allPackages
  ++ (with pkgs; [
    ghostscript
    mermaid-cli
  ]);
}
