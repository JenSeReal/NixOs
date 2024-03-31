{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.security.polkit;
in {
  options.JenSeReal.security.polkit = {
    enable = mkEnableOption "Whether or not to enable polkit.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ libsForQt5.polkit-kde-agent ];

    security.polkit = { enable = true; };

    systemd = {
      user.services.polkit-kde-authentication-agent-1 = {
        after = [ "graphical-session.target" ];
        description = "polkit-kde-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart =
            "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
