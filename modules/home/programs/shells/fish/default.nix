{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.JenSeReal.programs.shells.fish;
in
{
  options.JenSeReal.programs.shells.fish = {
    enable = mkEnableOption "Enable fish.";
  };

  config = mkIf cfg.enable { programs.fish.enable = true; };
}
