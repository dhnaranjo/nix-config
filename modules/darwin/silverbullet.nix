{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.silverbullet;

  silverbullet-binary = pkgs.stdenv.mkDerivation {
    pname = "silverbullet";
    version = "2.1.9";

    src = pkgs.fetchzip {
      url = "https://github.com/silverbulletmd/silverbullet/releases/download/2.1.9/silverbullet-server-darwin-aarch64.zip";
      hash = "sha256-HWCHkekmCBFceftRjRuK4IfoG1BBxaVCO/3KKmUGDF0=";
      stripRoot = false;
    };

    installPhase = ''
      mkdir -p $out/bin
      cp silverbullet $out/bin/
      chmod +x $out/bin/silverbullet
    '';
  };

  dataDir = "${config.users.users.${config.system.primaryUser}.home}/Documents/SilverBullet";
in
{
  options.services.silverbullet = {
    enable = lib.mkEnableOption "SilverBullet server";

    port = lib.mkOption {
      type = lib.types.port;
      default = 3456;
      description = "Port to run SilverBullet on";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = dataDir;
      description = "Directory to store SilverBullet data";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.primaryUser} =
      { lib, ... }:
      {
        home.activation.createSilverbulletDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          $DRY_RUN_CMD mkdir -p "${cfg.dataDir}"
        '';

        launchd.agents.silverbullet = {
          enable = true;
          config = {
            ProgramArguments = [
              "${silverbullet-binary}/bin/silverbullet"
              cfg.dataDir
            ];

            EnvironmentVariables = {
              SB_PORT = toString cfg.port;
              SB_HOSTNAME = "127.0.0.1";
            };

            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "${
              config.users.users.${config.system.primaryUser}.home
            }/Library/Logs/silverbullet.log";
            StandardErrorPath = "${
              config.users.users.${config.system.primaryUser}.home
            }/Library/Logs/silverbullet.error.log";
          };
        };
      };
  };
}
