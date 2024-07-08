{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.system.shells.addons.caraspace;
in
{
  options.JenSeReal.system.shells.addons.caraspace = {
    enable = mkEnableOption "Enable caraspace.";
  };

  config = mkIf cfg.enable { programs.caraspace.enable = true; };
}
