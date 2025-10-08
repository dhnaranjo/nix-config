{
  imports = [
    ./myusers.nix
  ];

  # Enable flakes and modern nix commands
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
