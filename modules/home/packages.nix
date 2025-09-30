{ pkgs, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    omnix

    # Unix tools
    ripgrep # Better `grep`
    fd
    sd
    tree
    gnumake
    moreutils # `vipe` and others https://joeyh.name/code/moreutils/

    # Nix dev
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt

    (pkgs.claude-code.overrideAttrs (old: {
      version = "2.0.1";
      src = pkgs.fetchzip {
        url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.1.tgz";
        hash = "sha256-LUbDPFa0lY74MBU4hvmYVntt6hVZy6UUZFN0iB4Eno8=";
      };
    }))
    f3d
  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
  programs = {
    # Better `cat`
    bat.enable = true;
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf.enable = true;
    jq.enable = true;
    # Install btop https://github.com/aristocratos/btop
    btop.enable = true;
    yt-dlp.enable = true;
  };
}
