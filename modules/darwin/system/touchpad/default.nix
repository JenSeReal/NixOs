{ config, lib, ... }:

with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.system.touchpad;
in {
  options.JenSeReal.system.touchpad = with types; {
    enable = mkEnableOption "Whether or not to manage touchpad settings.";
  };

  config = mkIf cfg.enable { };
}
