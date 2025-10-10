{
  config,
  pkgs,
  lib,
  ...
}:
let
  mcpServers = import ../mcp-servers { inherit config lib pkgs; };
in
{
  imports = mcpServers.modules;

  mcp-servers = {
    exa.enable = true;
    ref.enable = true;
    github.enable = true;
    serena.enable = false;
    git.enable = false;
    memory.enable = false;
    sequential-thinking.enable = true;
    nixos.enable = true;
    filesystem.enable = true;
  };

  programs.opencode = {
    enable = true;

    settings = {
      model = "anthropic/claude-sonnet-4-5";
      autoupdate = true;

      mcp = { };
    };

    # Global instructions (AGENTS.md)
    rules = builtins.readFile ../../apps/ai-agents/AGENTS.md;
  };

  # OpenCode configuration files
  home.file = {
    # OpenCode command files
    ".config/opencode/command" = {
      source = ../../apps/ai-agents/commands;
      recursive = true;
    };

    ".config/opencode/agent" = {
      source = ../../apps/ai-agents/agents;
      recursive = true;
    };
  };
}
