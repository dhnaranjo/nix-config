# Language Module Auto-Importer
#
# Philosophy: Structure around semantic boundaries, not consumption patterns.
# Languages are atomic units - all tooling (formatter, editor, packages) lives together.
#
# Each language module exports: { treefmt = {...}; nvf = {...}; packages = [...]; }
# This auto-importer aggregates them for consumers (treefmt-nix, nvf, home-manager).
#
# To add language support: Create modules/languages/{name}.nix following the pattern.
# See python.nix or ruby.nix for examples. No manual wiring needed.
#
# Returns:
#   - languages: individual language configs by name
#   - treefmtConfigs: list of all treefmt configs
#   - nvfModules: list of all nvf modules
#   - allPackages: flattened list of all packages
{ pkgs, lib }:
with builtins;
let
  languageFiles = filter (fn: fn != "default.nix" && lib.hasSuffix ".nix" fn) (
    attrNames (readDir ./.)
  );
  fileToName = fn: lib.removeSuffix ".nix" fn;
  importLanguage = fn: import ./${fn} { inherit pkgs lib; };

  languages = listToAttrs (
    map (fn: {
      name = fileToName fn;
      value = importLanguage fn;
    }) languageFiles
  );

  treefmtConfigs = lib.mapAttrsToList (_: lang: lang.treefmt) languages;
  nvfModules = lib.mapAttrsToList (_: lang: lang.nvf) languages;
  allPackages = lib.flatten (lib.mapAttrsToList (_: lang: lang.packages) languages);
in
{
  inherit languages;
  inherit treefmtConfigs nvfModules allPackages;
}
