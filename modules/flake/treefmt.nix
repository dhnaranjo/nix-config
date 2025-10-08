{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem = { pkgs, lib, ... }:
    let
      langs = import ../languages { inherit pkgs lib; };
    in
    {
      treefmt = lib.mkMerge langs.treefmtConfigs;
    };
}
