{ config, pkgs, lib, ... }:
with lib;
with lib.JenSeReal;

let cfg = config.JenSeReal.system.fonts;
in {
  imports = [ ../../../shared/system/fonts/default.nix ];

  config = mkIf cfg.enable {
    default = {
      fonts = with pkgs;
        [ sketchybar-app-font ] ++ cfg.default ++ cfg.additional;
    };

    system = { defaults = { NSGlobalDomain = { AppleFontSmoothing = 1; }; }; };
  };
}
