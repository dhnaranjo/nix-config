{ config, ... }:
{
  programs.opencode = {
    enable = true;

    settings = {
      model = "anthropic/claude-sonnet-4-20250514";
      autoupdate = true;

      mcp = {
        exa = {
          type = "local";
          command = [
            "npx"
            "-y"
            "exa-mcp-server"
          ];
          enabled = true;
          environment = {
            # EXA_API_KEY = "{file:${config.sops.secrets.exa-api-key.path}}";
          };
        };

        ref = {
          type = "local";
          command = [
            "npx"
            "ref-tools-mcp@latest"
          ];
          enabled = true;
          environment = {
            # REF_API_KEY = "{file:${config.sops.secrets.ref-mcp-api-key.path}}";
          };
        };

        github = {
          type = "local";
          command = [
            "podman"
            "run"
            "-i"
            "--rm"
            "-e"
            "GITHUB_PERSONAL_ACCESS_TOKEN"
            "ghcr.io/github/github-mcp-server"
          ];
          enabled = true;
          environment = {
            # GITHUB_PERSONAL_ACCESS_TOKEN = "{file:${config.sops.secrets.github-token.path}}";
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
