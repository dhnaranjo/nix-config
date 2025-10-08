{ config, ... }:
let
  home = config.home.homeDirectory;
  secretsFile = ../../secrets/secrets.enc.yaml;
in
{
  # Configure SOPS with age key
  sops = {
    age.sshKeyPaths = [ "${home}/.ssh/id_ed25519" ];

    defaultSopsFile = secretsFile;

    # MCP API key secrets
    secrets = {
      exa-api-key = {
        mode = "0400";
        key = "exa-api-key";
      };

      ref-mcp-api-key = {
        mode = "0400";
        key = "ref-mcp-api-key";
      };

      github-token = {
        mode = "0400";
        key = "github-token";
      };
    };
  };
}
