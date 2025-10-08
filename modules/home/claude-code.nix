{
  flake,
  config,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
  mcp-servers = inputs.mcp-servers-nix.lib;
in
{
  # Claude Code configuration using mcp-servers-nix framework
  home.file.".config/claude/claude_desktop_config.json".source = mcp-servers.mkConfig pkgs {
    format = "json";
    fileName = "claude_desktop_config.json";

    programs = {
      # GitHub MCP server with authentication via passwordCommand
      github = {
        enable = true;
        passwordCommand = {
          GITHUB_PERSONAL_ACCESS_TOKEN = [
            "${pkgs.coreutils}/bin/cat"
            config.sops.secrets.github-token.path
          ];
        };
      };
    };

    # Custom servers for Exa and Ref (URL-based SSE MCPs)
    # Using passwordCommand to set env vars, then referencing them in URLs via {env:}
    settings.servers = {
      exa = {
        type = "sse";
        url = "https://mcp.exa.ai/mcp?exaApiKey={env:EXA_API_KEY}";
        passwordCommand = {
          EXA_API_KEY = [
            "${pkgs.coreutils}/bin/cat"
            config.sops.secrets.exa-api-key.path
          ];
        };
      };

      ref = {
        type = "sse";
        url = "https://api.ref.tools/mcp?apiKey={env:REF_API_KEY}";
        passwordCommand = {
          REF_API_KEY = [
            "${pkgs.coreutils}/bin/cat"
            config.sops.secrets.ref-mcp-api-key.path
          ];
        };
      };
    };
  };

  # Claude Code configuration files (commands and agents)
  home.file = {
    ".config/claude/command" = {
      source = ../../apps/claude-code/commands;
      recursive = true;
    };

    ".config/claude/agent" = {
      source = ../../apps/claude-code/agents;
      recursive = true;
    };

    # Global instructions (equivalent to CLAUDE.md)
    ".config/claude/CLAUDE.md".text = builtins.readFile ../../apps/claude-code/CLAUDE.md;
  };
}
