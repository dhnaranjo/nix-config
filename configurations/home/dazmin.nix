{ inputs, self, ... }:
{
  imports = [
    self.homeModules.default
  ];

  me = {
    username = "dazmin";
    fullname = "Desmond Naranjo";
    email = "itsdesmond@hey.com";
  };

  home.stateVersion = "25.11";
}
