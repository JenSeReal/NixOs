{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.types) mkBoolOpt;
  cfg = config.JenSeReal.system;
in
{
  options.JenSeReal.system = {
    enable = mkBoolOpt true "Wether to enable custom system stuff.";
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    programs.bash.enable = true;
    programs.bash.enableCompletion = false;
    environment.systemPackages = with pkgs; [
      direnv
      nix-direnv
      jq
    ];

    system = {
      activationScripts.postUserActivation.text = ''
        # activateSettings -u will reload the settings from the database and apply them to the current session,
        # so we do not need to logout and login again to make the changes take effect.
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';

      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };

      defaults = {
        dock = {
          autohide = true;
          autohide-delay = 0.0;
          autohide-time-modifier = 0.2;
          expose-animation-duration = 0.2;
          mineffect = "scale";
          minimize-to-application = true;
          mouse-over-hilite-stack = true;
          tilesize = 48;
          launchanim = false;
          static-only = false;
          showhidden = true;
          show-recents = false;
          show-process-indicators = true;
          orientation = "bottom";
          mru-spaces = false;
          wvous-tl-corner = 7;
          wvous-tr-corner = 12;
          wvous-bl-corner = 14;
          wvous-br-corner = 2;
        };
        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          CreateDesktop = false;
          FXDefaultSearchScope = "SCcf";
          FXEnableExtensionChangeWarning = false;
          # NOTE: Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
          FXPreferredViewStyle = "Nlsv";
          QuitMenuItem = true;
          ShowStatusBar = false;
          _FXShowPosixPathInTitle = true;
        };
        trackpad = {
          ActuationStrength = 0;
          Clicking = true;
          FirstClickThreshold = 1;
          SecondClickThreshold = 1;
          TrackpadRightClick = true;
          TrackpadThreeFingerDrag = true;
        };
        screencapture = {
          disable-shadow = true;
          location = "$HOME/Pictures/screenshots/";
          type = "png";
        };
        ".GlobalPreferences" = {
          "com.apple.mouse.scaling" = 1.0;
        };
        NSGlobalDomain = {
          "com.apple.sound.beep.feedback" = 0;
          "com.apple.sound.beep.volume" = 0.0;
          AppleKeyboardUIMode = 3;
          ApplePressAndHoldEnabled = false;

          AppleShowAllExtensions = false;
          AppleShowScrollBars = "Automatic";
          NSAutomaticWindowAnimationsEnabled = false;
          _HIHideMenuBar = false;

          KeyRepeat = 2;
          InitialKeyRepeat = 15;

          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
        };
        CustomUserPreferences = {
          NSGlobalDomain = {
            WebKitDeveloperExtras = true;
            AppleSpacesSwitchOnActivate = false;
          };
          "com.apple.finder" = {
            ShowExternalHardDrivesOnDesktop = false;
            ShowHardDrivesOnDesktop = false;
            ShowMountedServersOnDesktop = false;
            ShowRemovableMediaOnDesktop = false;
            _FXSortFoldersFirst = true;
          };
          "com.apple.desktopservices" = {
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          "com.apple.screensaver" = {
            askForPassword = 1;
            askForPasswordDelay = 0;
          };
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
          "com.apple.print.PrintingPrefs" = {
            "Quit When Finished" = true;
          };
          "com.apple.SoftwareUpdate" = {
            AutomaticCheckEnabled = true;
            ScheduleFrequency = 1;
            AutomaticDownload = 1;
            CriticalUpdateInstall = 1;
          };
          "com.apple.ImageCapture".disableHotPlug = true;
          "com.apple.commerce".AutoUpdate = true;
        };
      };
    };
  };
}
