{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    let
      # Auto-import all language configurations
      langs = import ../languages { inherit pkgs lib; };

      # Base nvf configuration from the existing file
      baseConfig = import ../home/neovim/nvf.nix { inherit pkgs; };

      # Build neovim using standalone nvf
      neovimConfig = inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [ baseConfig ] ++ langs.nvfModules;
      };
    in
    {
      # Expose neovim package
      packages.neovim = neovimConfig.neovim;
    };
}
