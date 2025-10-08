{ config, pkgs, ... }:
{
  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "uninstall";
      autoUpdate = false;
      upgrade = false;
    };

    casks = [
      "claude"
      "firefox"
      "hey-desktop"
    ];
  };

  # Remove packages that must be handled by Homebrew
  home-manager.users.dazmin = {
    programs = {
      firefox.package = null;
    };
  };
}
