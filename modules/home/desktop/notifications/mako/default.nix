{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.desktop.notifications.mako;
in
{
  options.JenSeReal.desktop.notifications.mako = {
    enable = mkEnableOption "Mako.";
  };
  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      defaultTimeout = 10000;
    };
  };
}
