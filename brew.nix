{...}:
{
  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      cleanup = "zap";
    };
    # We only using this to install things that do not work thru Nix, or are not available
    casks = [
      "rubymine"
      "1password"
    ];
  };
}
