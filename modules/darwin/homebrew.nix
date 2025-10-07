{ config, ... }:
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
      "ghostty"
      "claude"
      "firefox"
    ];
  };

  # Remove packages that must be handled by Homebrew
  # Consider package/nur/gigamonster256.ghostty-darwin
  home-manager.users.dazmin = {
    programs = {
      ghostty.package = null;
      firefox.package = null;
    };
  };
}
