{ config, pkgs, lib, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  home.stateVersion = "22.05";

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  # Git n GitHub
  programs.git = {
    enable = true;
    difftastic = {
      enable = true;
      background = "dark";
    };
    userEmail = "itsdesmond@hey.com";
    userName = "Desmond Naranjo";
  };
  programs.gh = {
    enable = true;
    extensions = [
      pkgs.gh-dash
    ];
  };

  # Editors
  programs.helix.enable = true;

  home.packages = with pkgs; [
    # Core cli packages
    coreutils
    curl
    wget

    # Apps
    # raycast via Homebrew
    # _1password via Homebrew

    # Dev stuff
    ruby_3_2
    nodejs
    yarn
    jq
    gptcommit

    # Nix helpers
    nil # Language server
    cachix # Makes stuff faster?
  ] ++ lib.optionals stdenv.isDarwin [
    m-cli # useful macOS CLI commands
  ];

  # Misc configuration files --------------------------------------------------------------------{{{
}
