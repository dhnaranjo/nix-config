{ config, pkgs, ... }:
{
  programs.opencode = {
    enable = true;

    settings = {
      model = "anthropic/claude-sonnet-4-5";
      autoupdate = true;

      mcp = {
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
