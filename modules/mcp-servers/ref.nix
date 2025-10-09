{ config, lib, ... }:
let
  cfg = config.mcp-servers.ref;
in
{
  options.mcp-servers.ref = {
    enable = lib.mkEnableOption "Ref MCP server for documentation search";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode.settings.mcp.ref = {
      type = "remote";
      url = "https://api.ref.tools/mcp?apiKey={file:${config.sops.secrets.ref-mcp-api-key.path}}";
      enabled = true;
    };
  };
}
