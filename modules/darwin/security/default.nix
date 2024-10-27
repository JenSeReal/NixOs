{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.security;
in {
  options.JenSeReal.security = with types; {
    enable = mkEnableOption "Wether to enable security stuff.";
  };

  config = mkIf cfg.enable { security.pam.enableSudoTouchIdAuth = true; };
}
