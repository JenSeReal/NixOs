{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.JenSeReal.programs.shells.nushell;
in
{
  options.JenSeReal.programs.shells.nushell = {
    enable = mkEnableOption "Enable nushell.";
  };

  config = mkIf cfg.enable { programs.nushell.enable = true; };
}
