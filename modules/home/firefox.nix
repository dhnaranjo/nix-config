{
  pkgs,
  lib,
  config,
  ...
}:
let
  buildFirefoxXpiAddon = pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon;

  # Can grab ID value with ex: `curl -O https://addons.mozilla.org/firefox/downloads/file/4562821/icloud_passwords-3.1.27.xpi --output-dir /tmp  -w '%{filename_effective}' | xargs -I {} acat {} manifest.json  | jq --raw-output '.browser_specific_settings.gecko.id'`
  customAddons = {
    icloud-passwords = buildFirefoxXpiAddon {
      pname = "icloud-passwords";
      version = "3.1.27";
      addonId = "password-manager-firefox-extension@apple.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4562821/icloud_passwords-3.1.27.xpi";
      sha256 = "0zqnkvs4f2d78k3klhl3qfqxv12d6hcqsdwkr4pmxmyd6hm2mcn1";
      meta = with lib; {
        homepage = "https://apple.com";
        description = "For Apple passwords";
        license = licenses.mit;
        mozPermissions = [
          "nativeMessaging" # Exchange messages with programs other than Firefox
          "privacy" # Read and modify privacy settings
          "tabs" # Access browser tabs
          "webNavigation" # Access browser activity during navigation
          "<all_urls>" # Access your data for all websites
        ];
        platforms = platforms.all;
      };
    };
  };
in
{
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      extensions.packages =
        with pkgs.nur.repos.rycee.firefox-addons;
        [
          ublock-origin
          privacy-badger
        ]
        ++ (with customAddons; [
          icloud-passwords
        ]);

      settings = {
        "browser.startup.page" = 0;
        "browser.newtabpage.enabled" = false;
        "browser.newtab.url" = "about:blank";

        "browser.contentblocking.category" = "strict";
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

        "extensions.pocket.enabled" = false;

        "browser.contentblocking.report.lockwise.enabled" = false;
        "browser.contentblocking.report.monitor.enabled" = false;

        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
      };
    };
  };
}
