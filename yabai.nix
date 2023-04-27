{ pkgs, lib, ... }:
let
  spacebarHeight = 26;
  spacebarDisplay = "main";
in
{
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      layout = "bsp";
      window_gap = 10;
      top_padding = 10;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      external_bar = "${spacebarDisplay}:${toString spacebarHeight}:0";
    };
    extraConfig = ''
      yabai -m rule --add app='System Preferences' manage=off
      yabai -m config window_border on
      yabai -m config window_border_width 6
      yabai -m config active_window_border_color 0xff775759
    yabai -m config normal_window_border_color 0x0000000000
    '';
  };

  system.defaults.NSGlobalDomain._HIHideMenuBar = true;
  services.spacebar = {
    enable = true;
    package = pkgs.spacebar;
    config = {
      display = spacebarDisplay;
      height = spacebarHeight;
      icon_font = ''"Font Awesome 6 Free:Solid:12.0"'';
    };
  };
  launchd.daemons.yabai-sa = lib.mkForce {
    script = ''
      ${pkgs.yabai}/bin/yabai --load-sa
    '';
    serviceConfig.RunAtLoad = true;
    serviceConfig.KeepAlive.SuccessfulExit = false;
    serviceConfig.StandardErrorPath = "/var/log/yabai_daemon.err.log";
    serviceConfig.StandardOutPath = "/var/log/yabai_daemon.out.log";
  };
}
