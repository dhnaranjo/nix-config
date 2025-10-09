{ config, lib, pkgs, ... }:
let
  cfg = config.mcp-servers.sequential-thinking;

  mcp-server-sequential-thinking = pkgs.writeShellApplication {
    name = "mcp-server-sequential-thinking";
    runtimeInputs = [ pkgs.nodejs ];
    text = ''
      exec npx -y @modelcontextprotocol/server-sequential-thinking "$@"
    '';
  };
in
{
  options.mcp-servers.sequential-thinking = {
    enable = lib.mkEnableOption "Sequential thinking MCP server for step-by-step reasoning";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode.settings.mcp.sequential-thinking = {
      type = "local";
      command = [ "${mcp-server-sequential-thinking}/bin/mcp-server-sequential-thinking" ];
      enabled = true;
    };
  };
}
