# See /modules/darwin/* for actual settings
# This file is just *top-level* configuration.
{
  flake,
  ...
}:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ inputs.nur.overlays.default ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "flatbutt";

  system.primaryUser = "dazmin";

  home-manager.backupFileExtension = "hm-backup";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Used for backwards compatibility, please read the changelog before changing. `darwin-rebuild changelog`
  system.stateVersion = 6;
}
