{
  description = "A home-manager template providing useful tools & settings for Nix-based development";

  inputs = {
    # Principle inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # System management
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flake-parts modules for system/home configuration
    # Docs: https://flake.parts/options/easy-hosts.html
    easy-hosts.url = "github:tgirlcloud/easy-hosts";

    # Software inputs
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nur.url = "github:nix-community/NUR";
    nixpkgs-firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Import flake-parts modules
      # All options documented at: https://flake.parts/options/
      imports = [
        # Official home-manager flake-parts module
        # Docs: https://flake.parts/options/home-manager.html
        inputs.home-manager.flakeModules.home-manager

        # easy-hosts for NixOS/Darwin configuration
        # Docs: https://flake.parts/options/easy-hosts.html
        inputs.easy-hosts.flakeModule

        # Your custom flake modules
        ./modules/flake/devshell.nix
        ./modules/flake/treefmt.nix
      ];

      # Supported systems
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      # ===== Darwin/NixOS Hosts Configuration =====
      # Managed by easy-hosts flake-parts module
      # Options: https://flake.parts/options/easy-hosts.html
      easy-hosts = {
        # Shared configuration for all hosts
        shared = {
          modules = [
            ./modules/darwin # Auto-imports default.nix
          ];

          # Note: easy-hosts automatically provides 'inputs' and 'self' to all modules
          # No need to configure specialArgs.flake wrapper
        };

        # Per-class configuration (darwin, nixos, etc)
        perClass = class: {
          modules = [
            # Add home-manager to all darwin hosts
            (if class == "darwin" then inputs.home-manager.darwinModules.home-manager else { })
            (
              if class == "darwin" then
                {
                  # Make inputs/self available to home-manager modules
                  home-manager.extraSpecialArgs = {
                    inherit inputs;
                    inherit self;
                  };
                }
              else
                { }
            )
          ];
          specialArgs = { };
        };

        # Define individual hosts
        hosts = {
          flatbutt = {
            class = "darwin";
            arch = "aarch64";
            modules = [
              ./configurations/darwin/flatbutt.nix
            ];
          };
        };
      };

      # Export reusable modules
      # Home configuration is deployed via darwin integration (see modules/darwin/common/myusers.nix)
      flake.darwinModules.default = ./modules/darwin;
      flake.homeModules.default = ./modules/home;
    };
}
