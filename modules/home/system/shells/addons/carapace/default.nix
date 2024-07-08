{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.system.shells.addons.carapace;
in
{
  options.JenSeReal.system.shells.addons.carapace = {
    enable = mkEnableOption "Enable carapace.";
  };

  config = mkIf cfg.enable { programs.carapace.enable = true; };
}
