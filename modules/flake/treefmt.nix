{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { pkgs, lib, ... }:
    {
      treefmt = {
        programs = {
          nixfmt.enable = true;
          rubocop.enable = true;
          ruff-check.enable = true;
          ruff-format.enable = true;
        };

        settings.formatter = {
          rubocop = {
            options = [ "-A" ];
          };
        };
      };
    };
}
