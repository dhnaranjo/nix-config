{ ... }:
{
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # Navigation
      alt - h : yabai -m window --focus west || yabai -m display --focus west
      alt - j : yabai -m window --focus south || yabai -m display --focus south
      alt - k : yabai -m window --focus north || yabai -m display --focus north
      alt - l : yabai -m window --focus east || yabai -m display --focus east
    '';
  };
}
