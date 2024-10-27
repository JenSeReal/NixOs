{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.desktop-environment.amethyst;
in {
  options.JenSeReal.desktop-environment.amethyst = {
    enable = mkEnableOption "Enable amethyst desktop environment";
  };

  config = mkIf cfg.enable { JenSeReal.window-manager.amethyst.enable = true; };
}
