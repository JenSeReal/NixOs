{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.desktop.screen-locker.swaylock-effects;
in {
  options.JenSeReal.desktop.screen-locker.swaylock-effects = {
    enable = mkEnableOption "Whether or not to add swaylock-effects.";
  };

  config = mkIf cfg.enable {
    security.pam.services.swaylock = { };

    environment.systemPackages = with pkgs; [ swaylock-effects ];
  };
}
