{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.desktop.bar.sketchybar;
in {
  options.JenSeReal.desktop.bar.sketchybar = with types; {
    enable = mkEnableOption "Wether to enable sketchybar.";
  };

  config = mkIf cfg.enable { services.sketchybar.enable = true; };
}
