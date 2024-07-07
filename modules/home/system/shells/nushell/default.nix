{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.system.shells.nushell;
in
{
  options.JenSeReal.system.shells.nushell = {
    enable = mkEnableOption "Enable nushell.";
  };

  config = mkIf cfg.enable { programs.nushell.enable = true; };
}
