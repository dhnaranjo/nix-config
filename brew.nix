{...}:
let
  brewPrefix = "/opt/homebrew/bin";
in
{
  homebrew = {
    enable = true;
    brewPrefix = brewPrefix;
    onActivation = {
      upgrade = true;
      cleanup = "zap";
    };
    # We only using this to install things that do not work thru Nix, or are not available
    brews = [
      "dashing" # Create Dash docsets
    ];
    casks = [
      "kitty"
      "rubymine"
      "1password"
      "1password-cli"
      "raycast"
      "visual-studio-code"
      "chromium"
      "dash"
      "figma"
      "slack"
      "spotify"
      "adguard"
      "key-codes"
    ];
  };
}
