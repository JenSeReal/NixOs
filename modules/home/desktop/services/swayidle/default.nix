{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe getExe';
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.desktop.service.swayidle;

  resumeCommand = "${getExe pkgs.wlopm} --on \*";
in
{
  options.${namespace}.desktop.service.swayidle = {
    enable = mkBoolOpt false "Whether to enable swayidle service.";
  };

  config = mkIf cfg.enable {
    services.swayidle = {
      enable = true;

      systemdTarget = "sway-session.target";
      events = [
        {
          event = "before-sleep";
          command = "${getExe config.programs.swaylock.package} -fF";
        }
        {
          event = "after-resume";
          command = "${getExe pkgs.wlopm} --on \*";
        }
        {
          event = "lock";
          command = "${getExe config.programs.swaylock.package} -fF";
        }
      ];
      timeouts = [
        {
          timeout = 30;
          command = "${getExe config.programs.swaylock.package} -fF";
        }
        {
          timeout = 60;
          command = "${getExe' pkgs.systemd "systemctl"} suspend -f";
          inherit resumeCommand;
        }
      ];
    };
  };
}
