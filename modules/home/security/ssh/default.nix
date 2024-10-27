{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.security.ssh;
in {
  options.JenSeReal.security.ssh = { enable = mkEnableOption "Enable ssh."; };

  config = mkIf cfg.enable { programs.ssh.enable = true; };
}
