{ lib, config, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.programs.cli.home-manager;
in
{
  options.JenSeReal.programs.cli.home-manager = {
    enable = mkEnableOption "home-manager";
  };

  config = mkIf cfg.enable { programs.home-manager.enable = true; };
}
