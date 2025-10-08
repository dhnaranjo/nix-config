{ ... }:

{
  # Need to copy the apps because otherwise spotlight does not find them.
  home-manager.users.dazmin =
    { lib, ... }:
    {
      home.activation = {
        copyNixApps = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          # Create directory for the applications
          mkdir -p "$HOME/Applications/Nix-Apps"

          # Remove old entries
          rm -rf "$HOME/Applications/Nix-Apps"/*

          # Check if Applications directory exists
          if [ ! -d "$HOME/Applications/Home Manager Apps" ]; then
            echo "No Home Manager Apps directory found, skipping..."
            exit 0
          fi

          # Get the target of the symlink
          NIXAPPS=$(readlink -f "$HOME/Applications/Home Manager Apps")

          # If readlink fails, use the path directly
          if [ -z "$NIXAPPS" ]; then
            NIXAPPS="$HOME/Applications/Home Manager Apps"
          fi

          # For each application
          for app_source in "$NIXAPPS"/*.app; do
            # Skip if no .app files found
            [ -e "$app_source" ] || continue
            if [ -d "$app_source" ] || [ -L "$app_source" ]; then
                appname=$(basename "$app_source")
                target="$HOME/Applications/Nix-Apps/$appname"
                
                # Copy the Info.plist file
                if [ -f "$app_source/Contents/Info.plist" ]; then
                  mkdir -p "$target/Contents"
                  cp -f "$app_source/Contents/Info.plist" "$target/Contents/"
                fi

                # Copy icon files
                if [ -d "$app_source/Contents/Resources" ]; then
                  mkdir -p "$target/Contents/Resources"
                  find "$app_source/Contents/Resources" -name "*.icns" -exec cp -f {} "$target/Contents/Resources/" \;
                fi

                # Symlink the MacOS directory (contains the actual binary)
                if [ -d "$app_source/Contents/MacOS" ]; then
                  mkdir -p "$target/Contents"
                  rm -rf "$target/Contents/MacOS"
                  ln -sfn "$app_source/Contents/MacOS" "$target/Contents/MacOS"
                fi
                
                # Symlink other directories
                for dir in "$app_source/Contents"/*; do
                  dirname=$(basename "$dir")
                  if [ "$dirname" != "Info.plist" ] && [ "$dirname" != "Resources" ] && [ "$dirname" != "MacOS" ]; then
                    ln -sfn "$dir" "$target/Contents/$dirname"
                  fi
                done
              fi
              done
        '';
      };
    };
}
