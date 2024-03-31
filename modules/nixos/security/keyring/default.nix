{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.security.keyring;
in {
  options.JenSeReal.security.keyring = {
    enable = mkEnableOption "Whether to enable gnome keyring.";
  };

  config = mkIf cfg.enable { services.gnome.gnome-keyring.enable = true; };
}
