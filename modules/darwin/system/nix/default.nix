{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.${namespace}.system.nix;
in
{
  imports = [ (lib.snowfall.fs.get-file "modules/common/system/nix/default.nix") ];

  config = mkIf cfg.enable {
    services.nix-daemon.enable = true;

    nix = {
      settings = {
        build-users-group = "nixbld";

        extra-sandbox-paths = [
          "/System/Library/Frameworks"
          "/System/Library/PrivateFrameworks"
          "/usr/lib"
          "/private/tmp"
          "/private/var/tmp"
          "/usr/bin/env"
        ];

        # FIX: shouldn't disable, but getting sandbox max size errors on darwin
        # darwin-rebuild --rollback on testing changing
        sandbox = lib.mkForce false;
      };
      extraOptions = ''
        connect-timeout = 10
        keep-going = true
        always-allow-substitutes = true
      '';
      gc = {
        automatic = true;
        interval = {
          Day = 7;
          Hour = 3;
        };
        options = "--delete-older-than 2d";
        user = config.${namespace}.user.name;
      };
      optimise = {
        interval = {
          Day = 7;
          Hour = 4;
        };

        user = config.${namespace}.user.name;
      };
    };
  };
}
