# Auto-import all language modules in this directory
# Returns an attrset with:
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
