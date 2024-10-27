{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let

  cfg = config.JenSeReal.desktop-environment.hyprland;
in {
  options.JenSeReal.desktop-environment.hyprland = {
    enable = mkEnableOption "Hyprland.";
  };

  config = mkIf cfg.enable {
    # JenSeReal = {
    #   desktop.addons = {
    #     rofi = enabled;
    #     hyprpaper = enabled;
    #   };

    #   suites = {
    #     wlroots = enabled;
    #   };
    # };

    services.kanshi.enable = true;
    JenSeReal.desktop = {
      window-managers.hyprland.enable = true;
      bars.waybar.enable = true;
      launchers.kickoff.enable = true;
      launchers.anyrun.enable = true;
      notifications.mako.enable = true;
      idle-managers.swayidle.enable = true;
      screen-lockers.swaylock-effects.enable = true;
      terminal-emulator.kitty.enable = true;
      layout-manager.kanshi.enable = true;
      layout-manager.way-displays.enable = true;
      # library.qt.enable = true;
    };
    JenSeReal.gui.browser.firefox.enable = true;
  };
}
