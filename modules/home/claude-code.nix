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
}
