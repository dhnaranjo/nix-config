{ config, pkgs, lib, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  home.stateVersion = "22.05";

  # https://github.com/malob/nixpkgs/blob/master/home/default.nix

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

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
    _1password
    kitty
    raycast

    # Services
    colima
    docker-client

    # Dev stuff
    ruby_3_2
    jq
  ] ++ lib.optionals stdenv.isDarwin [
    m-cli # useful macOS CLI commands
  ];

  # Misc configuration files --------------------------------------------------------------------{{{

  # https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
  home.file.".stack/config.yaml".text = lib.generators.toYAML {} {
    templates = {
      scm-init = "git";
      params = {
        author-name = "Desmond Naranjo"; # config.programs.git.userName;
        author-email = "itsdesmond@hey.com"; # config.programs.git.userEmail;
        github-username = "dhnaranjo";
      };
    };
    nix.enable = true;
  };

}