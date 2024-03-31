{ config, lib, pkgs, ... }:

with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.system.shells.addons.starship;
in {
  options.JenSeReal.system.shells.addons.starship = with types; {
    enable = mkEnableOption "Whether or not to use fish as a shell.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ starship ]; };
}
