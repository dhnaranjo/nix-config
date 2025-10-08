{
  inputs,
  self,
  ...
}:
{
  imports = [
    self.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.sops-nix.darwinModules.sops
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.nur.overlays.default
    inputs.nixpkgs-firefox-darwin.overlay
    inputs.mcp-servers-nix.overlays.default
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "flatbutt";

  system.primaryUser = "dazmin";

  home-manager.backupFileExtension = "hm-backup";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  # Used for backwards compatibility, please read the changelog before changing. `darwin-rebuild changelog`
  system.stateVersion = 6;
}
