# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

# Default command when 'just' is run without arguments
default:
  @just --list

# Update nix flake
[group('Main')]
update:
  nix flake update

# Lint nix files
[group('dev')]
lint:
  nix fmt

# Check nix flake
[group('dev')]
check:
  nix flake check

# Manually enter dev shell
[group('dev')]
dev:
  nix develop

# Deploy system and home-manager configuration
[group('Main')]
deploy:
  darwin-rebuild switch --flake .#flatbutt

# Get the store path for a named flake input
[group('dev')]
inputPath NAME:
  nix eval .#inputPaths.{{NAME}} --raw
