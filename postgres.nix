{ config, pkgs, ... }:
let
    pgDataRoot = "/users/dazmin/.local/share/postgresql";
    pgDataDir = "${pgDataRoot}/14";
in
{
  services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql_14;
      dataDir = pgDataDir;
      initdbArgs = [
        "-D ${pgDataDir}"
      ];
      authentication = "local all postgres trust";
    };
  };

  # Create the PostgreSQL data directory, if it does not exist.
  system.activationScripts.preActivation = {
    enable = true;
    text = ''
      if [ ! -d "${pgDataRoot}/" ]; then
        echo "creating PostgreSQL data directory..."
        sudo mkdir -m 750 -p ${pgDataRoot}/
        chown -R dazmin:staff ${pgDataRoot}/
      fi
    '';
  };

  launchd.user.agents.postgresql.serviceConfig = {
    StandardErrorPath = "${pgDataRoot}/postgres.error.log";
    StandardOutPath = "${pgDataRoot}/postgres.out.log";
  };

  home-manager.users = {
    dazmin = {
      xdg.dataFile."postgresql/.keep".text = "";
    };
  };
}
