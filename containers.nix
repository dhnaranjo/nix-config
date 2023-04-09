{ config, pkgs, ... }:
let
  cfg = config.services.colima;
in
{
  home-manager.users.dazmin.home = {
    sessionVariables.DOCKER_HOST = "unix:///Users/dazmin/.colima/default/docker.sock";
    packages = with pkgs; [
      colima
      docker-client
      (writeShellScriptBin "browserless" ''
        colima start
        docker run -d --rm \
          -p 8403:3000 \
          --name browserless \
          browserless/chrome
    '')
    ];
  };
}
