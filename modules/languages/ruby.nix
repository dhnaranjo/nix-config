{ pkgs, lib }:
{
  treefmt = {
    programs.rubocop.enable = true;
    settings.formatter.rubocop = {
      options = [ "-A" ];
      excludes = [ "vendor/**" ];
    };
  };

  nvf = {
    vim.languages.ruby = {
      enable = true;
      treesitter.enable = true;
      lsp.enable = false; # Broken, nokogiri bullshit
    };
  };

  packages = with pkgs; [
    ruby_3_3
    rubocop
  ];
}
