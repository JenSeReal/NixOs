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
  cfg = config.${namespace}.entertainment.gaming.steam;
in
{
  options.${namespace}.entertainment.gaming.steam = {
    enable = mkEnableOption "Whether or not to enable pipewire.";
  };

  config = mkIf cfg.enable {
    programs.steam = enabled;
    environment.systemPackages = with pkgs; [
      libgdiplus
      steamPackages.steamcmd
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
