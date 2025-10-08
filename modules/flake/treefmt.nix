{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { pkgs, lib, ... }:
    let
      # Auto-import all language configurations
      langs = import ../languages { inherit pkgs lib; };
    in
    {
      treefmt = lib.mkMerge (
        [
          {
            programs = {
              nixfmt.enable = true;
              ruff-check.enable = true;
              ruff-format.enable = true;
            };
          }
        ]
        ++ langs.treefmtConfigs
      );
    };
}
