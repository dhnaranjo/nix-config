{ pkgs, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
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
  ];

  programs = {
    # Better `cat`
    # Disabled because of error related to Ghostty install via homebrew. Revisit
    bat.enable = false;
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf.enable = true;
    jq.enable = true;
    # Install btop https://github.com/aristocratos/btop
    btop.enable = true;
    yt-dlp.enable = true;

    ghostty.enable = true;
  };
}
