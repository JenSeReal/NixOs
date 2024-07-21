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
  cfg = config.${namespace}.desktop.window-manager.wayland.sway;
in
{
  options.${namespace}.desktop.window-manager.wayland.sway = {
    enable = mkBoolOpt false "Whether or not to enable sway window manager.";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "${getExe pkgs.wezterm}";
        menu = "${getExe pkgs.kickoff}";
        bars = [ { command = "${getExe pkgs.waybar}"; } ];
        input = {
          "*" = {
            xkb_layout = "de";
            xkb_variant = "nodeadkeys";
            xkb_options = "caps:escape";
          };
        };
        startup = [
          {
            command = "${getExe' pkgs.networkmanagerapplet "nm-applet"} --indicator";
            always = true;
          }
        ];
        window.titlebar = false;
        window.hideEdgeBorders = "smart";
      };
    };
  };
}
