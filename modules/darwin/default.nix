# This is your nix-darwin configuration.
# For home configuration, see /modules/home/*
{ pkgs, ... }:
let
  pam_monitor = pkgs.callPackage ./pam-monitor { };
in
{
  imports = [
    ./common
    ./homebrew.nix
    ./apps-fix.nix
  ];

  # Monitor-based authentication + TouchID fallback for sudo
  environment.etc."pam.d/sudo_local".text = ''
    auth       sufficient     ${pam_monitor}/lib/pam/pam_monitor.so monitor_uuid=10ACB142-0000-0000-1321-0104B5462778
    auth       sufficient     pam_tid.so
  '';

  # Configure macOS system
  # More flatbutts => https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/rich-demo/modules/system.nix
  system = {
    defaults = {
      dock = {
        autohide = true;
        static-only = true;
        # customize Hot Corners
        wvous-tl-corner = 2; # top-left - Mission Control
        wvous-tr-corner = 14; # top-right - Quick Note
        wvous-bl-corner = 3; # bottom-left - Application Windows
        wvous-br-corner = 4; # bottom-right - Desktop
      };

      finder = {
        _FXShowPosixPathInTitle = true; # show full path in finder title
        AppleShowAllExtensions = true; # show all file extensions
        FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
        QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
        CreateDesktop = false; # no icons on desktop
        NewWindowTarget = "Home";
      };

      screencapture = { }; # Look into these!
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
