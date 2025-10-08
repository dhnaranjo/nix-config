{ config, ... }:
let
  home = config.home.homeDirectory;
in
{
  # Configure SOPS with age key
  sops = {
    age.sshKeyPaths = [ "${home}/.ssh/id_ed25519" ];

    defaultSopsFile = ../../secrets/secrets.enc.yaml;

    # MCP API key secrets
    secrets = {
      exa-api-key = {
        sopsFile = ../../secrets/secrets.enc.yaml;
        mode = "0400";
        key = "exa-api-key";
      };

      ref-mcp-api-key = {
        sopsFile = ../../secrets/secrets.enc.yaml;
        mode = "0400";
        key = "ref-mcp-api-key";
      };

      github-token = {
        sopsFile = ../../secrets/secrets.enc.yaml;
        mode = "0400";
        key = "github-token";
      };
    };
  };
}
