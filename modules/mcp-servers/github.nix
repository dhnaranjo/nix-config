{ config, lib, pkgs, ... }:
let
  cfg = config.mcp-servers.github;
in
{
  options.mcp-servers.github = {
    enable = lib.mkEnableOption "GitHub MCP server for version control operations";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode.settings.mcp.github = {
      type = "local";
      command = [
        "${pkgs.github-mcp-server}/bin/github-mcp-server"
        "stdio"
      ];
      enabled = true;
      environment = {
        GITHUB_PERSONAL_ACCESS_TOKEN = "{file:${config.sops.secrets.github-token.path}}";
      };
    };
  };
}
