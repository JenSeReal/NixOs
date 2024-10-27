{ config, lib, inputs, pkgs, ... }:
with lib;
with lib.JenSeReal;
let
  inherit (inputs) anyrun;

  cfg = config.JenSeReal.desktop.launchers.anyrun;
in
{
  options.JenSeReal.desktop.launchers.anyrun = {
    enable = mkEnableOption "Anyrun.";
  };

  imports = [
    anyrun.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = [
          inputs.anyrun.packages.${pkgs.system}.applications
        ];
        width = { fraction = 0.3; };
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = false;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = null;
      };
    };
  };
}
