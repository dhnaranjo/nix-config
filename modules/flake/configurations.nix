# Explicit configuration wiring
# This replaces nixos-unified's autowiring magic with visible, understandable code.
#
# What this does:
# - Wires configurations/darwin/*.nix → darwinConfigurations.*
# - Wires configurations/home/*.nix → homeConfigurations.*
# - Provides 'flake' specialArgs to all modules (like nixos-unified did)
# - Imports all modules from modules/darwin/ and modules/home/

{ inputs, self, ... }:

let
  inherit (inputs) nixpkgs nix-darwin home-manager;
  
  # Helper to create the 'flake' specialArgs that modules expect
  mkFlakeArgs = config: {
    flake = {
      inherit inputs;
      inherit (inputs) self;
      inherit config;
    };
  };
in
{
  flake = {
    # Darwin Configurations
    # Maps: configurations/darwin/flatbutt.nix → darwinConfigurations.flatbutt
    darwinConfigurations.flatbutt = nix-darwin.lib.darwinSystem {
      specialArgs = mkFlakeArgs self.darwinConfigurations.flatbutt.config or {};
      
      modules = [
        # The machine-specific configuration
        ../../configurations/darwin/flatbutt.nix
        
        # Home-manager integration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          # Pass 'flake' args to home-manager modules too
          home-manager.extraSpecialArgs = mkFlakeArgs self.darwinConfigurations.flatbutt.config or {};
        }
      ];
    };

    # Home Manager Configurations
    # Maps: configurations/home/dazmin.nix → homeConfigurations.dazmin
    homeConfigurations.dazmin = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      
      extraSpecialArgs = mkFlakeArgs self.homeConfigurations.dazmin.config or {};
      
      modules = [
        ../../configurations/home/dazmin.nix
      ];
    };

    # Reusable modules (for importing in configurations)
    darwinModules.default = ../../modules/darwin;
    homeModules.default = ../../modules/home;
    
    # If you add nixosConfigurations, add them here:
    # nixosConfigurations.server = nixpkgs.lib.nixosSystem {
    #   specialArgs = mkFlakeArgs self.nixosConfigurations.server.config or {};
    #   modules = [ ../../configurations/nixos/server.nix ];
    # };
  };
}
