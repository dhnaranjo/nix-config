{ pkgs, ... }:
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

  # Current upstream script calls --check-sa & --install-sa, removed in v5
  launchd.daemons.yabai-sa = {
    script = ''
      ${pkgs.yabai}/bin/yabai --load-sa
    '';
  };
}
