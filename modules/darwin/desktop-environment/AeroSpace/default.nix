{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.desktop-environment.aerospace;
in {
  options.JenSeReal.desktop-environment.aerospace = {
    enable = mkEnableOption "Enable aerospace desktop environment";
  };

  config =
    mkIf cfg.enable { JenSeReal.window-manager.aerospace.enable = true; };
}
