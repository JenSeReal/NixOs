{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    getExe
    getExe'
    mkOptionDefault
    mkEnableOption
    ;
  cfg = config.${namespace}.desktop.window-manager.wayland.sway;

  modifier = config.wayland.windowManager.sway.config.modifier;

  clamshell = pkgs.writeShellScript "clamshell.sh" ''
    # Set your laptop screen name
    set $laptop_screen 'eDP-1'

    # Clamshell mode or lock & sleep
    # This is a if/else statement: [ outputs_count == 1 ] && true || false
    bindswitch --reload --locked lid:on exec '[ $(swaymsg -t get_outputs | grep name | wc -l) == 1 ] && (${getExe' pkgs.systemd "systemctl"} suspend -f) || (swaymsg output $laptop_screen disable)'

    bindswitch --reload --locked lid:off output $laptop_screen enable
  '';
in
{
  options.${namespace}.desktop.window-manager.wayland.sway = {
    enable = mkEnableOption "Whether or not to enable sway window manager.";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GSK_RENDERER = "gl";
    };

    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "${getExe config.programs.wezterm.package}";
        menu = " ${getExe pkgs.yofi}";
        bars = [ { command = "${getExe pkgs.waybar}"; } ];
        input = {
          "*" = {
            xkb_layout = "de";
            xkb_variant = "nodeadkeys";
            xkb_options = "caps:escape";
            xkb_numlock = "enabled";
          };

          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
            middle_emulation = "enabled";
          };
        };
        startup = [
          {
            command = "${getExe' pkgs.networkmanagerapplet "nm-applet"} --indicator";
            always = true;
          }
          {
            command = "${clamshell.outPath}";
            always = true;
          }
        ];
        keybindings = mkOptionDefault {
          "${modifier}+l" = "exec ${getExe config.programs.swaylock.package}";
          "${modifier}+Shift+c" = "reload; exec ${getExe' pkgs.systemd "systemctl"} --user restart kanshi";
        };
        window.titlebar = false;
        window.hideEdgeBorders = "smart";
        window.commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              app_id = "^firefox$";
            };
          }
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              class = "^Firefox$";
            };
          }
        ];
      };
    };
  };
}
