{ pkgs, config, ... }:
let
  pam_monitor = pkgs.callPackage ./pam-monitor { };

  # Shell script to encode password for /etc/kcpassword
  kcpasswordEncode = pkgs.writeShellScript "kcpassword-encode" ''
    thisString="$1"
    cipherHex_array=( 7D 89 52 23 D2 BC DD EA A3 B9 1F )
    thisStringHex_array=( $(/bin/echo -n "''${thisString}" | ${pkgs.xxd}/bin/xxd -p -u | ${pkgs.gnused}/bin/sed 's/../& /g') )

    if [ "''${#thisStringHex_array[@]}" -lt 12  ]; then
      padding=$(( 12 -  ''${#thisStringHex_array[@]} ))
    elif [ "$(( ''${#thisStringHex_array[@]} % 12 ))" -ne 0  ]; then
      padding=$(( (12 - ''${#thisStringHex_array[@]} % 12) ))
    else
      padding=12
    fi

    for ((i=0; i < $(( ''${#thisStringHex_array[@]} + ''${padding})); i++)); do
      charHex_cipher=''${cipherHex_array[$(( $i % 11 ))]}
      charHex=''${thisStringHex_array[$i]}
      printf "%02X" "$(( 0x''${charHex_cipher} ^ 0x''${charHex:-00} ))" | ${pkgs.xxd}/bin/xxd -r -p > /dev/stdout
    done
  '';
in
{
  imports = [
    ./common
    ./homebrew.nix
    ./apps-fix.nix
    ./ghostty.nix
  ];

  # Configure sops for system-level secrets
  sops = {
    defaultSopsFile = ../../secrets/secrets.enc.yaml;
    age.sshKeyPaths = [ "/Users/dazmin/.ssh/id_ed25519" ];

    secrets.dazmin-password = {
      mode = "0400";
      owner = "root";
    };
  };

  # Monitor-based authentication + TouchID fallback for sudo
  environment.etc."pam.d/sudo_local".text = ''
    auth       sufficient     ${pam_monitor}/lib/pam/pam_monitor.so monitor_uuid=10ACB142-0000-0000-1321-0104B5462778
    auth       sufficient     pam_tid.so
  '';

  environment.systemPackages = [ pkgs.defaultbrowser ];

  system.activationScripts.userActivation.text = ''
    sudo -u dazmin ${pkgs.defaultbrowser}/bin/defaultbrowser firefox

    sudo -u dazmin defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    sudo -u dazmin defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    sudo -u dazmin defaults write com.apple.frameworks.diskimages skip-verify -bool true
    sudo -u dazmin defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
    sudo -u dazmin defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
  '';

  # Configure autologin with kcpassword
  system.activationScripts.postActivation.text = ''
    # Create /etc/kcpassword for autologin
    if [ -f "${config.sops.secrets.dazmin-password.path}" ]; then
      PASSWORD=$(cat "${config.sops.secrets.dazmin-password.path}")
      ${kcpasswordEncode} "$PASSWORD" > /etc/kcpassword
      chown root:wheel /etc/kcpassword
      chmod 600 /etc/kcpassword
      echo "✓ Created /etc/kcpassword for autologin"
    else
      echo "⚠ Password secret not found, autologin will not work"
    fi
  '';

  # Configure macOS system
  # More options: https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/rich-demo/modules/system.nix
  system = {
    defaults = {
      dock = {
        autohide = true;
        static-only = true;
        wvous-tl-corner = 2; # top-left - Mission Control
        wvous-tr-corner = 14; # top-right - Quick Note
        wvous-bl-corner = 3; # bottom-left - Application Windows
        wvous-br-corner = 4; # bottom-right - Desktop
      };

      finder = {
        _FXShowPosixPathInTitle = true; # show full path in finder title
        AppleShowAllExtensions = true; # show all file extensions
        FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
        QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
        CreateDesktop = false; # no icons on desktop
        NewWindowTarget = "Home";
      };

      screencapture = { }; # Look into these!

      loginwindow = {
        autoLoginUser = "dazmin";
      };

      LaunchServices = {
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
      };

      CustomUserPreferences = {
        NSGlobalDomain = {
          NSQuitAlwaysKeepsWindows = false;
        };
        "com.apple.loginwindow" = {
          TALLogoutSavesState = false; # Disable window reopening on logout/restart
        };
        "com.apple.systempreferences" = {
          NSQuitAlwaysKeepsWindows = false;
        };
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
