{ config, ... }:
{
  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  programs = {
    git = {
      enable = true;
      userName = config.me.fullname;
      userEmail = config.me.email;
      ignores = [
        "*~"
        "*.swp"
      ];
      aliases = {
        ci = "commit";
      };
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
    gh.enable = true;
    lazygit.enable = true;
  };
}
