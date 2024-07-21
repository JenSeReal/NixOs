{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe';
  inherit (lib.${namespace}) mkBoolOpt;
  cfg = config.${namespace}.desktop.bars.waybar;

  style = builtins.readFile ./styles.css;
  synthwave84 = builtins.readFile ./synthwave84.css;
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
          layer = "top";
          position = "bottom";
          spacing = 0;
          modules-left = [
            "sway/workspaces"
            "custom/arGap"
            "custom/archthing"
            "custom/wsGap"
          ];
          modules-center = [
            "custom/mgl"
            "sway/window"
            "custom/mgr"
          ];
          modules-right = [
            "custom/paGap"
            "pulseaudio"
            "custom/blGap"
            "backlight"
            "custom/baGap"
            "battery"
            "custom/netGap"
            "network"
            "custom/trayGap"
            "tray"
            "custom/clGap"
            "clock"
          ];
          "sway/window" = {
            "all-outputs" = true;
            "offscreen-css" = true;
            "offscreen-css-text" = "(inactive)";
          };
          "custom/arGap" = {
            format = "";
            tooltip = false;
          };
          "custom/archthing" = {
            format = "";
            tooltip = false;
            "on-click" = "rofi -show drun -normal-window -steal-focus -modes drun,run,filebrowser,window";
          };
          "custom/wsGap" = {
            format = "";
            tooltip = false;
          };
          "custom/mgl" = {
            format = "";
            tooltip = false;
          };
          "custom/mgr" = {
            format = "";
            tooltip = false;
          };
          "custom/paGap" = {
            format = "";
            tooltip = false;
          };
          "custom/blGap" = {
            format = "";
            tooltip = false;
          };
          "custom/baGap" = {
            format = "";
            tooltip = false;
          };
          "custom/netGap" = {
            format = "";
            tooltip = false;
          };
          "custom/clGap" = {
            format = "";
            tooltip = false;
          };
          "custom/trayGap" = {
            format = "";
            tooltip = false;
          };
          clock = {
            format = "<span font='13'>{:%H:%M:%S}</span>";
            "tooltip-format" = "{:%A, %B %d, %Y | %H:%M %Z}";
            "on-click" = "galendae";
          };
          backlight = {
            format = "󰃠{icon}";
            tooltip = true;
            "tooltip-format" = "{percent}%";
            "format-icons" = [
              "󰣾"
              "󰣴"
              "󰣶"
              "󰣸"
              "󰣺"
            ];
          };
          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon}";
            "tooltip-format" = "{capacity}%  |  {time}";
            "format-charging" = "{icon}";
            "format-icons" = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          network = {
            format = "󰖩{icon}";
            "tooltip-format" = "{essid}  |  {ipaddr}  |  {ifname}";
            "format-icons" = [
              "󰣾"
              "󰣴"
              "󰣶"
              "󰣸"
              "󰣺"
            ];
            "on-click-right" = "${getExe' pkgs.networkmanagerapplet "nm-connection-editor"}";
            "format-disconnected" = "󰖩󰣽";
          };
          pulseaudio = {
            format = "󰕾{icon}";
            "tooltip-format" = "{volume}%";
            "format-muted" = "󰖁{icon}";
            "format-icons" = {
              default = [
                "󰣾"
                "󰣴"
                "󰣶"
                "󰣸"
                "󰣺"
              ];
            };
            "enable-bar-scroll" = true;
          };
        };
      };
      style = ''
        ${style}

        ${synthwave84}
      '';
    };
  };
}
