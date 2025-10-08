{
  self,
  pkgs,
  lib,
  config,
  ...
}:
let
  mapListToAttrs =
    m: f:
    lib.listToAttrs (
      map (name: {
        inherit name;
        value = f name;
      }) m
    );
in
{
  options = {
    myusers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of usernames";
      defaultText = "All users under ./configuration/users are included by default";
      default =
        let
          dirContents = builtins.readDir (self + /configurations/home);
          fileNames = builtins.attrNames dirContents; # Extracts keys: [ "dazmin.nix" ]
          regularFiles = builtins.filter (name: dirContents.${name} == "regular") fileNames; # Filters for regular files
          baseNames = map (name: builtins.replaceStrings [ ".nix" ] [ "" ] name) regularFiles; # Removes .nix extension
        in
        baseNames;
    };
  };

  config = {
    # For home-manager to work.
    # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
    users.users = mapListToAttrs config.myusers (
      name:
      lib.optionalAttrs pkgs.stdenv.isDarwin {
        home = "/Users/${name}";
      }
      // lib.optionalAttrs pkgs.stdenv.isLinux {
        isNormalUser = true;
      }
    );

    home-manager.users = mapListToAttrs config.myusers (name: {
      imports = [ (self + /configurations/home/${name}.nix) ];
    });

    nix.settings.trusted-users = [
      "root"
    ]
    ++ config.myusers;
  };
}
