{ lib, config, ... }:

with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.system.time;
in {
  options.JenSeReal.system.time = with types; {
    enable = mkEnableOption "Whether or not to use the variables set.";
    time_zone = mkOpt str "Europe/Berlin" "The time zone to use";
  };

  config = mkIf cfg.enable { time.timeZone = cfg.time_zone; };
}
