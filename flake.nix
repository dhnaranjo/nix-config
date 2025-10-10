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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {
        imports = [
          inputs.home-manager.flakeModules.home-manager
          inputs.easy-hosts.flakeModule

          ./modules/flake/devshell.nix
          ./modules/flake/treefmt.nix
          ./modules/flake/nvf.nix
        ];

        systems = [ "aarch64-darwin" ];

        easy-hosts = {
          shared = {
            modules = [
              ./modules/darwin
              (
                { pkgs, ... }:
                {
                  home-manager.extraSpecialArgs = withSystem pkgs.system (
                    { config, ... }:
                    {
                      inherit inputs self;
                      neovimPackage = config.packages.neovim;
                    }
                  );
                }
              )
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

        flake.darwinModules.default = ./modules/darwin;
        flake.homeModules.default = ./modules/home;

        flake.inputPaths = builtins.mapAttrs (name: input: input.outPath) inputs;
      }
    );
}
