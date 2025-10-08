# Language Modules Architecture

## Overview

This document describes the unified language configuration architecture that co-locates treefmt-nix and nvf configurations in a single file per language.

## Architecture

### Key Design Principles

1. **Single source of truth**: Each language has ONE file (`modules/languages/{language}.nix`)
2. **Co-located configuration**: Formatter (treefmt), editor (nvf), and packages all defined together
3. **Same evaluation context**: Both treefmt-nix and nvf use standalone mode within flake-parts `perSystem`
4. **Pure functions**: Language modules are plain Nix functions, not NixOS-style modules

### Directory Structure

```
modules/
  languages/
    ruby.nix         # All Ruby configuration
    openscad.nix     # All OpenSCAD configuration
    python.nix       # (future) All Python configuration
  flake/
    treefmt.nix      # Imports language configs for formatting
    nvf.nix          # Imports language configs for editor (standalone nvf)
  home/
    neovim/
      default.nix    # Simplified - just installs packages
      nvf.nix        # Base nvf config
```

## Language Module Format

Each language module at `modules/languages/{language}.nix` exports an attribute set with three keys:

```nix
{ pkgs, lib }:
{
  # Treefmt configuration fragment
  treefmt = {
    programs.{formatter}.enable = true;
    settings.formatter.{formatter} = {
      options = [ ... ];
      excludes = [ ... ];
    };
  };

  # nvf configuration fragment
  nvf = {
    vim.languages.{language}.enable = true;
    vim.treesitter.grammars = [ ... ];
    vim.lsp.lspconfig.sources.{lsp} = ''
      -- Lua LSP configuration
    '';
  };

  # Language tooling packages
  packages = with pkgs; [
    {language-runtime}
    {formatters}
    {linters}
  ];
}
```

## Integration Points

### 1. treefmt-nix (modules/flake/treefmt.nix)

Uses the pre-aggregated `treefmtConfigs` list:

```nix
{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem = { pkgs, lib, ... }:
  let
    langs = import ../languages { inherit pkgs lib; };
  in {
    treefmt = lib.mkMerge (
      [{ programs.nixfmt.enable = true; }]
      ++ langs.treefmtConfigs  # Pre-aggregated list
    );
  };
}
```

### 2. nvf (modules/flake/nvf.nix)

Uses the pre-aggregated `nvfModules` list:

```nix
{ inputs, ... }: {
  perSystem = { pkgs, lib, system, ... }:
  let
    langs = import ../languages { inherit pkgs lib; };
    baseConfig = import ../home/neovim/nvf.nix { inherit pkgs; };
    
    neovimConfig = inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [
        { config.vim = baseConfig.settings.vim; }
      ] ++ langs.nvfModules;  # Pre-aggregated list
    };
  in {
    packages.neovim = neovimConfig.neovim;
  };
}
```

### 3. home-manager (modules/home/neovim/default.nix)

Uses the pre-aggregated `allPackages` list:

```nix
{ inputs, pkgs, lib, ... }:
let
  langs = import ../../languages { inherit pkgs lib; };
in {
  home.packages = [
    inputs.self.packages.${pkgs.system}.neovim
  ] ++ langs.allPackages;  # Pre-aggregated, flattened list
}
```

## Adding a New Language

To add support for a new language:

1. **Create language module** at `modules/languages/{language}.nix` following the standard format
2. **That's it!** The auto-importer (`modules/languages/default.nix`) will automatically:
   - Import your new language module
   - Add formatter config to treefmt
   - Add editor config to nvf
   - Add packages to home-manager

Example for Python:

```nix
# modules/languages/python.nix
{ pkgs, lib }:
{
  treefmt = {
    programs.ruff-check.enable = true;
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
  ];
}
```

Then in `modules/flake/treefmt.nix`:
```nix
let
  python = import ../languages/python.nix { inherit pkgs lib; };
in {
  treefmt = lib.mkMerge [
    # ...
    python.treefmt
  ];
}
```

And in `modules/flake/nvf.nix`:
```nix
let
  python = import ../languages/python.nix { inherit pkgs lib; };
in {
  neovimConfig = inputs.nvf.lib.neovimConfiguration {
    modules = [
      # ...
      python.nvf
    ];
  };
}
```

## Benefits

1. **Single file per language** - All related config in one place
2. **Easy to extend** - Just add a new language file and import it
3. **No evaluation context issues** - Both tools use same perSystem context
4. **Type-safe** - Can add schema validation later if needed
5. **Clear ownership** - Each language maintainer owns one file
6. **Testing friendly** - Can import and test language configs independently

## Auto-Import System

The `modules/languages/default.nix` file automatically discovers and imports all `.nix` files in the languages directory (except itself), then **exposes aggregated lists** for easy consumption:

```nix
# modules/languages/default.nix
{ pkgs, lib }:
with builtins;
let
  # Get all .nix files except default.nix
  languageFiles = filter 
    (fn: fn != "default.nix" && lib.hasSuffix ".nix" fn) 
    (attrNames (readDir ./.));

  # Import each language module
  languages = listToAttrs (
    map (fn: {
      name = lib.removeSuffix ".nix" fn;
      value = import ./${fn} { inherit pkgs lib; };
    }) languageFiles
  );

  # Pre-compute aggregated lists for consumers
  treefmtConfigs = lib.mapAttrsToList (_: lang: lang.treefmt) languages;
  nvfModules = lib.mapAttrsToList (_: lang: lang.nvf) languages;
  allPackages = lib.flatten (lib.mapAttrsToList (_: lang: lang.packages) languages);
in
{
  inherit languages;      # Individual configs by name
  inherit treefmtConfigs; # List of all treefmt configs
  inherit nvfModules;     # List of all nvf modules
  inherit allPackages;    # Flattened list of all packages
}
```

This returns an attribute set with both individual configs and aggregated lists:
```nix
{
  # Individual language configs
  languages = {
    ruby = { treefmt = {...}; nvf = {...}; packages = [...]; };
    openscad = { treefmt = {...}; nvf = {...}; packages = [...]; };
  };
  
  # Pre-aggregated lists for consumers
  treefmtConfigs = [ {...} {...} ];  # All treefmt configs
  nvfModules = [ {...} {...} ];      # All nvf modules
  allPackages = [ ... ];              # All packages flattened
}
```

## Known Limitations

1. **Ruby LSP disabled** - nokogiri gem fails to build on macOS (native extension issue)
2. **Home-manager nvf removed** - Now using standalone nvf exclusively

## Future Improvements

1. ~~Auto-discover language modules (scan directory, auto-import)~~ ✅ **DONE**
2. Add enable/disable options per language
3. Add schema validation for language module format
4. Create language module template generator
5. Document migration path for complex languages with nested configs
6. Add support for language-specific devshell dependencies
