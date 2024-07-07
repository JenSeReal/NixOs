{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.system.shells.fish;
in
{
  options.JenSeReal.system.shells.fish = {
    enable = mkEnableOption "Enable fish.";
  };

  config = mkIf cfg.enable { programs.fish.enable = true; };
}
