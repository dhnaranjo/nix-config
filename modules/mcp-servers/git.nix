{ config, lib, pkgs, ... }:
let
  cfg = config.mcp-servers.git;

  mcp-server-git = pkgs.writeShellApplication {
    name = "mcp-server-git";
    runtimeInputs = [ pkgs.uv ];
    text = ''
      exec uvx mcp-server-git "$@"
    '';
  };
in
{
  options.mcp-servers.git = {
    enable = lib.mkEnableOption "Git MCP server for version control operations";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode.settings.mcp.git = {
      type = "local";
      command = [ "${mcp-server-git}/bin/mcp-server-git" ];
      enabled = true;
    };
  };
}
