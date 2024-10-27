{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.virtualisation.docker;
in {
  options.JenSeReal.virtualisation.docker = {
    enable =
      mkEnableOption "Whether or not to enable common wlroots configuration.";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = [ "jfp" ];
  };
}
