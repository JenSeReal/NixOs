{ config, lib, ... }:

with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.system.power-management;
in {
  options.JenSeReal.system.power-management = with types; {
    enable = mkEnableOption "Whether or not to use powermanagement.";
  };

  config = mkIf cfg.enable {
    services.thermald = enabled;
    services.auto-cpufreq = enabled;
    powerManagement = { enable = true; };
    hardware.system76.power-daemon = enabled;
  };
}
