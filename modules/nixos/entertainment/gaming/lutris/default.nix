{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;

let cfg = config.JenSeReal.entertainment.gaming.lutris;
in {
  options.JenSeReal.entertainment.gaming.lutris = with types; {
    enable = mkEnableOption "Whether or not to enable pipewire.";
    extraLibraries =
      mkOpt (listOf package) [ ] "Extra libraries needed for Lutris games";
    extraPackages =
      mkOpt (listOf package) [ ] "Extra packages needed for Lutris games";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wineWowPackages.stagingFull
      wineWowPackages.waylandFull
      winetricks
      protontricks
      vulkan-tools
      (lutris.override {
        extraPkgs = pkgs: cfg.extraPackages;
        extraLibraries = pkgs: cfg.extraLibraries;
      })
    ];
  };
}
