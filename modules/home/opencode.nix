{ config, pkgs, ... }:
{
  programs.opencode = {
    enable = true;

    settings = {
      model = "anthropic/claude-sonnet-4-5";
      autoupdate = true;

      mcp = {
        # Web search and documentation
        exa = {
          type = "remote";
          url = "https://mcp.exa.ai/mcp?exaApiKey={file:${config.sops.secrets.exa-api-key.path}}";
          enabled = true;
        };

        ref = {
          type = "remote";
          url = "https://api.ref.tools/mcp?apiKey={file:${config.sops.secrets.ref-mcp-api-key.path}}";
          enabled = true;
        };

        # Version control
        github = {
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

        git = {
          type = "local";
          command = [
            "${pkgs.mcp-server-git}/bin/mcp-server-git"
          ];
          enabled = true;
        };

        # Persistent memory and reasoning
        memory = {
          type = "local";
          command = [
            "${pkgs.mcp-server-memory}/bin/mcp-server-memory"
          ];
          enabled = true;
        };

        sequential-thinking = {
          type = "local";
          command = [
            "${pkgs.mcp-server-sequential-thinking}/bin/mcp-server-sequential-thinking"
          ];
          enabled = true;
        };

        # Semantic code understanding
        serena = {
          type = "local";
          command = [
            "${pkgs.serena}/bin/serena"
            "start-mcp-server"
          ];
          enabled = true;
        };

        # NixOS package and option search
        nixos = {
          type = "local";
          command = [
            "${pkgs.mcp-nixos}/bin/mcp-nixos"
          ];
          enabled = true;
        };
      };
    };

    # Global instructions (equivalent to CLAUDE.md)
    rules = builtins.readFile ../../apps/claude-code/CLAUDE.md;
  };

  # OpenCode configuration files
  home.file = {
    # OpenCode command files
    ".config/opencode/command" = {
      source = ../../apps/claude-code/commands;
      recursive = true;
    };

    ".config/opencode/agent" = {
      source = ../../apps/claude-code/agents;
      recursive = true;
    };
  };
}
