{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;
  cfg = config.${namespace}.desktop.environment.sway;
in
{
  options.${namespace}.desktop.environment.sway = {
    enable = mkBoolOpt false "Whether or not to enable sway desktop enivronment.";
  };

  config = mkIf cfg.enable {
    ${namespace}.desktop = {
      window-manager.wayland.sway = enabled;
      bars.waybar = enabled;
    };
  };
}
