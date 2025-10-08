{
  description = "A home-manager template providing useful tools & settings for Nix-based development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Docs: https://flake.parts/options/easy-hosts.html
    easy-hosts.url = "github:tgirlcloud/easy-hosts";

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
      imports = [
        # Docs: https://flake.parts/options/home-manager.html
        inputs.home-manager.flakeModules.home-manager
        # Docs: https://flake.parts/options/easy-hosts.html
        inputs.easy-hosts.flakeModule

        ./modules/flake/devshell.nix
        ./modules/flake/treefmt.nix
      ];

      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      easy-hosts = {
        shared = {
          modules = [
            ./modules/darwin
            {
              # Pass inputs/self to home-manager modules (easy-hosts auto-provides these to darwin modules)
              home-manager.extraSpecialArgs = {
                inherit inputs self;
              };
            }
          ];
        };

        perClass = class: {
          modules = if class == "darwin" then [ inputs.home-manager.darwinModules.home-manager ] else [ ];
        };

        hosts = {
          flatbutt = {
            class = "darwin";
            arch = "aarch64";
            modules = [ ./configurations/darwin/flatbutt.nix ];
          };
        };
      };

      # Home configuration is deployed via darwin integration (see modules/darwin/common/myusers.nix)
      flake.darwinModules.default = ./modules/darwin;
      flake.homeModules.default = ./modules/home;
    };
}
