{
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.system.power;
in
{
  options.${namespace}.system.power = {
    enable = mkEnableOption "Whether or not to enable power settings.";
  };

  config = mkIf cfg.enable {
    power.sleep.computer = 5;
    power.sleep.display = 2;
  };
}
