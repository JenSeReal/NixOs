{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.JenSeReal.system.fonts;
in
{
  imports = [ ../../../shared/system/fonts/default.nix ];

  config = mkIf cfg.enable {
    default = {
      fonts = [ pkgs.sketchybar-app-font ] ++ cfg.default ++ cfg.additional;
    };

    system = {
      defaults = {
        NSGlobalDomain = {
          AppleFontSmoothing = 1;
        };
      };
    };
  };
}
