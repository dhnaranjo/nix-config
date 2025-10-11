{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.reverse-proxy;

  virtualHostsConfig = lib.concatStringsSep "\n\n" (
    lib.mapAttrsToList (
      name: hostCfg:
      let
        listenAddr = if hostCfg.listenPort == 443 then name else "${name}:${toString hostCfg.listenPort}";
      in
      ''
        ${listenAddr} {
          reverse_proxy localhost:${toString hostCfg.upstreamPort}
          tls internal
        }
      ''
    ) cfg.virtualHosts
  );

  caddyfile = pkgs.writeText "Caddyfile" ''
    {
      auto_https disable_redirects
    }

    ${virtualHostsConfig}
  '';

  hostsEntries = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: hostCfg: "127.0.0.1 ${name}") cfg.virtualHosts
  );
in
{
  options.services.reverse-proxy = {
    enable = lib.mkEnableOption "reverse proxy server";

    virtualHosts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            upstreamPort = lib.mkOption {
              type = lib.types.port;
              description = "Port of the upstream service to proxy to";
            };

            listenPort = lib.mkOption {
              type = lib.types.port;
              default = 443;
              description = "Port to listen on for incoming requests";
            };
          };
        }
      );
      default = { };
      description = "Virtual hosts to reverse proxy";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc.hosts.text = lib.mkAfter ''
      ${hostsEntries}
    '';

    environment.systemPackages = [ pkgs.nss pkgs.caddy ];

    environment.userLaunchAgents.reverse-proxy = {
      enable = true;
      target = "org.nixos.reverse-proxy.plist";
      text = lib.generators.toPlist { } {
        Label = "org.nixos.reverse-proxy";
        ProgramArguments = [
          "${pkgs.caddy}/bin/caddy"
          "run"
          "--config"
          "${caddyfile}"
          "--adapter"
          "caddyfile"
        ];
        EnvironmentVariables = {
          XDG_DATA_HOME = "${config.users.users.dazmin.home}/.local/share";
          XDG_CONFIG_HOME = "${config.users.users.dazmin.home}/.config";
        };
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "${config.users.users.dazmin.home}/.local/share/caddy/reverse-proxy.log";
        StandardErrorPath = "${config.users.users.dazmin.home}/.local/share/caddy/reverse-proxy.error.log";
      };
    };
  };
}
