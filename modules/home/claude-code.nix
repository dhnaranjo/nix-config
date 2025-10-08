{ ... }:
{
  programs.claude-code = {
    enable = true;
    settings = {
      includeCoAuthoredBy = false;
      model = "claude-sonnet-4-5";
      hooks.PostToolUse = [
        {
          matcher = "Edit|MultiEdit|Write";
          hooks = [
            {
              type = "command";
              command = "nix fmt $(jq -r '.tool_input.file_path')";
            }
          ];
        }
      ];
    };
  };

  # Claude Code configuration files
  home.file = {
    # Claude command files
    ".claude/commands" = {
      source = ../../apps/claude-code/commands;
      recursive = true;
    };

    ".claude/agents" = {
      source = ../../apps/claude-code/agents;
      recursive = true;
    };

    ".claude/CLAUDE.md".text = builtins.readFile ../../apps/claude-code/CLAUDE.md;
  };
}
