{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe;
  inherit (lib.${namespace}) mkBoolOpt;
  cfg = config.${namespace}.desktop.bars.waybar;
in
{
  options.${namespace}.desktop.bars.waybar = {
    enable = mkBoolOpt false "Whether or not to enable waybar.";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          "layer" = "top";
          "position" = "bottom";
          "modules-left" = [ "sway/workspaces" ];
          "modules-center" = [ "sway/window" ];
          "modules-right" = [
            "custom/media"
            "cpu"
            "memory"
            "tray"
            "backlight"
            "pulseaudio"
            "battery"
            "clock"
          ];

          "pulseaudio" = {
            "tooltip" = false;
            "scroll-step" = 1;
            "format" = "{icon} {volume}%";
            "format-muted" = "{icon} {volume}%";
            "on-click" = "pavucontrol";
            "format-icons" = {
              "default" = [
                ""
                ""
                ""
              ];
            };
          };

          "network" = {
            "tooltip" = false;
            "format-wifi" = "  {essid}";
            "format-ethernet" = "";
          };
          "backlight" = {
            "tooltip" = false;
            "format" = " {}%";
            "interval" = 1;
          };
          "battery" = {
            "states" = {
              "good" = 95;
              "warning" = 30;
              "critical" = 20;
            };
            "format" = "{icon}  {capacity}%";
            "format-charging" = " {capacity}%";
            "format-plugged" = " {capacity}%";
            "format-alt" = "{time} {icon}";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          "tray" = {
            "icon-size" = 18;
            "spacing" = 10;
          };
          "cpu" = {
            "interval" = 15;
            "format" = " {}%";
            "max-length" = 10;
          };
          "memory" = {
            "interval" = 30;
            "format" = " {}%";
            "max-length" = 10;
          };
          "custom/media" = {
            "interval" = 30;
            "format" = "{icon} {}";
            "return-type" = "json";
            "max-length" = 20;
            "format-icons" = {
              "spotify" = " ";
              "default" = " ";
            };
            "escape" = true;
            "exec" = "$HOME/.config/system_scripts/mediaplayer.py 2> /dev/null";
            "on-click" = "playerctl play-pause";
          };
        };
      };
      style = ./styles.css;
    };
  };
}
