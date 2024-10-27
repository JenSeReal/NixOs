{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.desktop.launcher.raycast;
in {
  options.JenSeReal.desktop.launcher.raycast = with types; {
    enable = mkEnableOption "Wether to enable raycast.";
  };

  config = mkIf cfg.enable {
    JenSeReal.cli.homebrew = {
      enable = true;
      additional_casks = [ "raycast" ];
    };
  };
}
