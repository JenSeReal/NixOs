{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.programs.gui.browser.firefox;
  defaultSettings = {
    "accessibility.typeaheadfind.enablesound" = false;
    "accessibility.typeaheadfind.flashBar" = 0;
    "browser.aboutConfig.showWarning" = false;
    "browser.aboutwelcome.enabled" = false;
    "browser.bookmarks.autoExportHTML" = true;
    "browser.bookmarks.showMobileBookmarks" = true;
    "browser.meta_refresh_when_inactive.disabled" = true;
    "browser.newtabpage.activity-stream.default.sites" = "";
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.search.hiddenOneOffs" = "Google,Amazon.com,Bing,DuckDuckGo,eBay,Wikipedia (en)";
    "browser.search.suggest.enabled" = false;
    "browser.search.defaultenginename" = "Google";
    "browser.search.order.1" = "Google";
    "browser.sessionstore.warnOnQuit" = true;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.ssb.enabled" = true;
    "browser.startup.homepage.abouthome_cache.enabled" = true;
    "browser.startup.page" = 3;
    "browser.tabs.firefox-view" = false;
    "browser.tabs.tabmanager.enabled" = false;
    "browser.translations.enable" = false;
    "browser.translations.autoTranslate" = false;
    "browser.translations.automaticallyPopup" = false;
    "browser.urlbar.keepPanelOpenDuringImeComposition" = true;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    # TODO: one of these doesn't work
    # "browser.urlbar.groupLabels.enabled" = false;
    # "browser.urlbar.shortcuts.bookmarks " = false;
    # "browser.urlbar.shortcuts.history " = false;
    # "browser.urlbar.shortcuts.tabs " = false;
    # "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    # "browser.urlbar.suggest.searches" = false;
    # "browser.urlbar.trimURLs" = false;
    # TODO: fix above
    "dom.storage.next_gen" = true;
    "dom.webgpu.enabled" = true;
    "dom.forms.autocomplete.formautofill" = false;
    "extensions.pocket.enabled" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "extensions.formautofill.addresses.enabled" = false;
    "general.autoScroll" = false;
    "general.smoothScroll.msdPhysics.enabled" = true;
    "geo.enabled" = false;
    "geo.provider.use_corelocation" = false;
    "geo.provider.use_geoclue" = false;
    "geo.provider.use_gpsd" = false;
    "intl.accept_languages" = "en-US = en";
    "media.eme.enabled" = true;
    "media.ffmpeg.vaapi.enabled" = true;
    "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
    "signon.rememberSignons" = false;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };
in
{
  options.JenSeReal.programs.gui.browser.firefox = with types; {
    enable = mkEnableOption "Whether or not to enable firefox.";
    extraConfig = mkOpt str "" "Extra configuration for the user profile JS file.";
    settings = mkOpt attrs defaultSettings "Settings to apply to the profile.";
    userChrome = mkOpt str "" "Extra configuration for the user chrome CSS file.";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          CaptivePortal = false;
          DisableFirefoxStudies = true;
          DisableFirefoxAccounts = true;
          DisableFormHistory = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisplayBookmarksToolbar = true;
          DontCheckDefaultBrowser = true;
          FirefoxHome = {
            Search = false;
            Pocket = false;
            Snippets = false;
            TopSites = false;
            Highlights = false;
          };
          PasswordManagerEnabled = false;
          PromptForDownloadLocation = false;
          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };
          ExtensionSettings = {
            "ebay@search.mozilla.org".installation_mode = "blocked";
            "amazondotcom@search.mozilla.org".installation_mode = "blocked";
            "bing@search.mozilla.org".installation_mode = "blocked";
            "ddg@search.mozilla.org".installation_mode = "blocked";
            "wikipedia@search.mozilla.org".installation_mode = "blocked";
          };
        };
      };

      profiles.${config.JenSeReal.user.name} = {
        inherit (cfg) extraConfig settings;
        inherit (config.JenSeReal.user) name;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          privacy-badger
          bitwarden
          clearurls
          decentraleyes
          duckduckgo-privacy-essentials
          ghostery
          privacy-badger
          languagetool
          disconnect
        ];
        userChrome = ''
          ${cfg.userChrome}
          .tabbrowser-tab .tab-close-button {
            visibility: collapse !important;
          }
          #tabs-newtab-button, #new-tab-button{
            display: none !important
          }
          .titlebar-buttonbox-container {
            display:none;
          }
        '';
        search = {
          force = true;
          default = "Google";
          order = [ "Google" ];
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "NixOS Wiki" = {
              urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@nw" ];
            };
            "Bing".metaData.hidden = true;
            "Amazon".metaData.hidden = true;
            "Wikipedia".metaData.hidden = true;
            "Google".metaData.alias = "@g";
          };
        };

      };
    };
  };
}
