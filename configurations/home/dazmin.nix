{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
  ];

  # Defined by /modules/home/me.nix
  # And used all around in /modules/home/*
  me = {
    username = "dazmin";
    fullname = "Desmond Naranjo";
    email = "itsdesmond@hey.com";
  };

  home.stateVersion = "25.11";
}
