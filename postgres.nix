{ ... }:
{
  services.postgresql.enable = true;
  #   services = {
  #   postgresql = {
  #     enable = true;
  #     package = pkgs.postgresql;
  #     # dataDir = /. + "/var/lib/postgresql/"; # Default value
  #   };
  # };

  # # Create the PostgreSQL data directory, if it does not exist.
  # system.activationScripts.preActivation = {
  #   enable = true;
  #   text = ''
  #     if [ ! -d "/var/lib/postgresql/" ]; then
  #       echo "creating PostgreSQL data directory..."
  #       sudo mkdir -m 775 -p /var/lib/postgresql/
  #       chown -R dazmin:staff /var/lib/postgresql/
  #     fi
  #   '';
  # };

  # # Direct log output to $XDG_DATA_HOME/postgresql for debugging.
  # launchd.user.agents.postgresql.serviceConfig = {
  #   # Un-comment these values instead to avoid a home-manager dependency.
  #   # StandardErrorPath = "/Users/dazmin/postgres.error.log";
  #   # StandardOutPath = "/Users/dazmin/postgres.out.log";
  #   StandardErrorPath = "/Users/dazmin/.local/share/postgresql/postgres.error.log";
  #   StandardOutPath = "/Users/dazmin/.local/share/postgresql/postgres.out.log";
  # };

  # home-manager.users = {
  #   dazmin = {
  #     # Create the directory ~/.local/share/postgresql/
  #     xdg.dataFile."postgresql/.keep".text = "";
  #   };
  # };
}