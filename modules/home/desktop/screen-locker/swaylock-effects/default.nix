{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.JenSeReal.desktop.screen-locker.swaylock-effects;
in
{
  options.JenSeReal.desktop.screen-locker.swaylock-effects = {
    enable = mkEnableOption "Whether or not to add swaylock-effects.";
  };

  config = mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;

      settings = {
        screenshots = true;
        ignore-empty-password = true;
        disable-caps-lock-text = true;
        grace = 10;

        clock = true;
        timestr = "%R";
        datestr = "%a, %e of %B";

        fade-in = "0.2";

        effect-blur = "10x2";
        effect-scale = "0.1";

        indicator = true;
        indicator-radius = 240;
        indicator-thickness = 20;
        indicator-caps-lock = true;
      };
    };
  };
}
