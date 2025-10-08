{
  flake,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (flake) inputs;

  # Use mcp-servers-nix to get the GitHub package, but build config manually for OpenCode
  mcp-packages = inputs.mcp-servers-nix.packages.${pkgs.system};

  # Generate OpenCode configuration directly (OpenCode format differs from Claude Desktop)
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    model = "anthropic/claude-sonnet-4-20250514";
    autoupdate = true;

    mcp = {
      # GitHub MCP server (local/stdio)
      github = {
        type = "local";
        enabled = true;
        command = [ "${lib.getExe mcp-packages.github-mcp-server}" ];
        environment = {
          # OpenCode supports {file:path} syntax for reading secrets
          GITHUB_PERSONAL_ACCESS_TOKEN = "{file:${config.sops.secrets.github-token.path}}";
        };
      };

      # Exa MCP server (remote/SSE)
      exa = {
        type = "remote";
        enabled = true;
        # OpenCode supports {file:path} syntax in URLs
        url = "https://mcp.exa.ai/mcp?exaApiKey={file:${config.sops.secrets.exa-api-key.path}}";
      };

      # Ref MCP server (remote/SSE)
      ref = {
        type = "remote";
        enabled = true;
        # OpenCode supports {file:path} syntax in URLs
        url = "https://api.ref.tools/mcp?apiKey={file:${config.sops.secrets.ref-mcp-api-key.path}}";
      };
    };
  };
in
{
  # OpenCode configuration
  home.file.".config/opencode/config.json".text = builtins.toJSON opencodeConfig;

  # OpenCode configuration files (commands and agents)
  home.file = {
    ".config/opencode/command" = {
      source = ../../apps/claude-code/commands;
      recursive = true;
    };

    ".config/opencode/agent" = {
      source = ../../apps/claude-code/agents;
      recursive = true;
    };

    # Global instructions (equivalent to CLAUDE.md)
    ".config/opencode/AGENTS.md".text = builtins.readFile ../../apps/claude-code/CLAUDE.md;
  };
}
