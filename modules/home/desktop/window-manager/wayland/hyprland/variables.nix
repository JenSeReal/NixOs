{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.JenSeReal.desktop.window-managers.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        "$mainMod" = "SUPER";
        "$mainModControl" = "SUPER_CONTROL";
        "$mainModShift" = "SUPER_SHIFT";

        # default applications
        "$term" = "${getExe pkgs.kitty}";
        "$browser" = "${getExe pkgs.firefox}";
        "$launcher" = "${getExe' pkgs.kickoff "kickoff"}";
        "$explorer" = "${getExe pkgs.cinnamon.nemo-with-extensions}";
        "$logout" = "${getExe pkgs.wlogout}";
        # "$mail" = "${getExe pkgs.thunderbird}";
        # "$editor" = "${getExe pkgs.neovim}";
        # "$explorer" = "${getExe pkgs.xfce.thunar}";
        # "$music" = "${getExe pkgs.spotify}";
        # "$notepad" = "code - -profile notepad - -unity-launch ~/Templates";
        # "$launchpad" = "${getExe pkgs.rofi} -show drun -config '~/.config/rofi/appmenu/rofi.rasi'";
        # "$looking-glass" = "${getExe pkgs.looking-glass-client}";
      };
    };
  };
}
