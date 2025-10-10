{ pkgs, ... }:
let
  curaengine = pkgs.callPackage ../../pkgs/darwin/curaengine.nix { };
in
{
  home.packages =
    (with pkgs; [
      omnix

      # Updating outdated Mac builtins
      coreutils
      findutils
      gnused
      gawk
      gnugrep
      curl
      wget
      openssh
      git
      rsync
      gnutar
      gzip
      bzip2
      xz
      bash
      zsh
      less

      # Unix tools
      ripgrep # Better `grep`
      fd
      sd
      tree
      gnumake
      moreutils # `vipe` and others https://joeyh.name/code/moreutils/

      atool
      # atool backends
      unzip
      zip
      p7zip
      unrar
      lzip

      # Nix dev
      cachix
      nil # Nix language server
      nix-info
      nixpkgs-fmt

      yt-dlp
      aria2
      openscad-unstable
    ])
    ++ [ curaengine ];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    btop.enable = true;
    yt-dlp.enable = true;
  };
}
