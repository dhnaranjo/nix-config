{
  imports = [
    ./myusers.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
