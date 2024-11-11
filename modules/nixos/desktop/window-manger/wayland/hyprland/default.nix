{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;
with lib.JenSeReal;
with inputs;
let
  cfg = config.JenSeReal.desktop.window-managers.hyprland;
in
{
  options.JenSeReal.desktop.window-managers.hyprland = with types; {
    enable = mkEnableOption "Whether or not to use Hyprland as the desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland";
      HYPRLAND_LOG_WLR = "1";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      #NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_RENDERER = "vulkan";
      #XDG_CURRENT_DESKTOP = "Hyprland";
      #XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    programs.dconf.enable = true;

    JenSeReal = {
      desktop.display-manager.tuigreet.enable = true;
      desktop.bars.waybar.enable = true;
      desktop.launchers.kickoff.enable = true;
      desktop.notifications.mako.enable = true;
      desktop.portals.xdg.enable = true;
      desktop.idle-managers.swayidle.enable = true;
      desktop.logout-menu.wlogout.enable = true;
      desktop.screen-locker.swaylock-effects.enable = true;
      desktop.libraries.qt.enable = true;
      desktop.layout-manager.kanshi.enable = true;
      desktop.layout-manager.way-displays.enable = true;
      desktop.layout-manager.wlr-randr.enable = true;
      hardware.audio.pipewire.enable = true;
      suites.wlroots.enable = true;
      security = {
        keyring.enable = true;
        polkit.enable = true;
        bitwarden.enable = true;
      };
      gui.browser.firefox.enable = true;
      gui.file-manager.nemo.enable = true;
      theming.stylix.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pciutils
      kitty
      swayosd
    ];

  };
}
