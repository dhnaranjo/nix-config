{ config, lib, pkgs, ... }:
let
  cfg = config.mcp-servers.memory;

  mcp-server-memory = pkgs.writeShellApplication {
    name = "mcp-server-memory";
    runtimeInputs = [ pkgs.nodejs ];
    text = ''
      exec npx -y @modelcontextprotocol/server-memory "$@"
    '';
  };
in
{
  options.mcp-servers.memory = {
    enable = lib.mkEnableOption "Memory MCP server for persistent memory";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode.settings.mcp.memory = {
      type = "local";
      command = [ "${mcp-server-memory}/bin/mcp-server-memory" ];
      enabled = true;
    };
  };
}
