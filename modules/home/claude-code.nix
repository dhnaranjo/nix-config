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
          hooks = [{
            type = "command";
            command = ''
              FILE_PATH=$(jq -r '.tool_input.file_path')

              case "$FILE_PATH" in
                *.nix)
                  nix fmt "$FILE_PATH"
                  ;;
                *.rb)
                  standardrb --fix "$FILE_PATH"
                  ;;
              esac
            '';
          }];
        }
      ];
    };
  };
}
