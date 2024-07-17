{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
with lib;
with lib.${namespace};

let
  cfg = config.${namespace}.desktop.environment.sway;
in
{
  options.${namespace}.desktop.environment.sway = with types; {
    enable = mkEnableOption "Whether or not to enable sway window manager.";
  };

  config = mkIf cfg.enable {
    ${namespace}.desktop = {
      window-manager.sway = enabled;
      display-manager.tuigreet = {
        enable = true;
        autologin = "jfp";
      };
    };

    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      mako
    ];
  };
}
