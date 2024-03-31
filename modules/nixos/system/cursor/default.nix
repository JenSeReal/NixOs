{ config, pkgs, lib, ... }:

with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.system.cursor;

  default = with pkgs; [
    phinger-cursors
    capitaine-cursors-themed
    bibata-cursors
    oreo-cursors-plus
    graphite-cursors
    JenSeReal.layan-cursors
  ];

in {
  options.JenSeReal.system.cursor = with types; {
    enable = mkEnableOption "Whether or not to enable additional cursors.";
    additional =
      mkOpt (listOf package) [ ] "Custom cursor packages to install.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = default ++ cfg.additional; };
}
