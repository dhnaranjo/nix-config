{ config, lib, pkgs, ... }:
let
  cfg = config.mcp-servers.filesystem;

  mcp-server-filesystem = pkgs.writeShellApplication {
    name = "mcp-server-filesystem";
    runtimeInputs = [ pkgs.nodejs ];
    text = ''
      exec npx -y @modelcontextprotocol/server-filesystem "$@"
    '';
  };
in
{
  options.mcp-servers.filesystem = {
    enable = lib.mkEnableOption "Filesystem MCP server for /nix/store access";
    path = lib.mkOption {
      type = lib.types.str;
      default = "/nix/store";
      description = "Path to grant filesystem access to";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.opencode.settings.mcp.readNixStore = {
      type = "local";
      command = [ "${mcp-server-filesystem}/bin/mcp-server-filesystem" cfg.path ];
      enabled = true;
    };
  };
}
