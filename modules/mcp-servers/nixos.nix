{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mcp-servers.nixos;
in
{
  options.mcp-servers.nixos = {
    enable = lib.mkEnableOption "NixOS MCP server for package and option search";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode.settings.mcp.nixos = {
      type = "local";
      command = [ "${pkgs.mcp-nixos}/bin/mcp-nixos" ];
      enabled = true;
    };
  };
}
