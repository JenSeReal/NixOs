{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;
  cfg = config.${namespace}.programs.gui.entertainment.gaming.steam;
in
{
  options.${namespace}.programs.gui.entertainment.gaming.steam = {
    enable = mkEnableOption "Whether or not to enable pipewire.";
  };

  config = mkIf cfg.enable {
    programs.steam = enabled;
    environment.systemPackages = with pkgs; [
      libgdiplus
      steamcmd
      # steam-tui

      wineWowPackages.waylandFull
      bottles
      gamescope
      lutris
      proton-caller
      protontricks
      protonup-ng
      protonup-qt
    ];
  };
}
