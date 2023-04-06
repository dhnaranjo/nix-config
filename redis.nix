{ config, pkgs, ... }:
let
    redisDataDir = "/Users/dazmin/.local/share/redis";
in
{
  services = {
    redis = {
      enable = true;
      dataDir = redisDataDir;
    };
  };

  # Create the PostgreSQL data directory, if it does not exist.
  system.activationScripts.preActivation = {
    enable = true;
    text = ''
      if [ ! -d "${redisDataDir}/" ]; then
        echo "creating Redis data directory..."
        sudo mkdir -m 750 -p ${redisDataDir}/
        chown -R dazmin:staff ${redisDataDir}/
      fi
    '';
  };
}
