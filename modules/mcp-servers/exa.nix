{ config, lib, ... }:
let
  cfg = config.mcp-servers.exa;
in
{
  options.mcp-servers.exa = {
    enable = lib.mkEnableOption "Exa MCP server for web search and documentation";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode.settings.mcp.exa = {
      type = "remote";
      url = "https://mcp.exa.ai/mcp?exaApiKey={file:${config.sops.secrets.exa-api-key.path}}";
      enabled = true;
    };
  };
}
