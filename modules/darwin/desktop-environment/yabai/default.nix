{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.desktop-environment.yabai;
in {
  options.JenSeReal.desktop-environment.yabai = {
    enable = mkEnableOption "Enable Yabai desktop environment";
  };

  config = mkIf cfg.enable {
    JenSeReal.window-manager.yabai.enable = true;
    JenSeReal.tools.skhd.enable = true;
    JenSeReal.desktop.bar.sketchybar.enable = true;
  };
}
