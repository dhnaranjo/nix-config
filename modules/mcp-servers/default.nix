{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Get all .nix files in this directory except default.nix
  moduleFiles = builtins.filter (name: name != "default.nix" && lib.hasSuffix ".nix" name) (
    builtins.attrNames (builtins.readDir ./.)
  );

  # Convert filenames to module paths
  modules = map (name: ./. + "/${name}") moduleFiles;
in
{
  inherit modules;
}
