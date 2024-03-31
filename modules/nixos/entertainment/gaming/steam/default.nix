{ config, lib, ... }:
with lib;
with lib.JenSeReal;

let cfg = config.JenSeReal.entertainment.gaming.steam;
in {
  options.JenSeReal.entertainment.gaming.steam = with types; {
    enable = mkEnableOption "Whether or not to enable pipewire.";
  };

  config = mkIf cfg.enable { programs.steam = enabled; };
}
