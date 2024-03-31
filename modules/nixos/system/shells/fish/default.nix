{ config, lib, pkgs, ... }:

with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.system.shells.fish;
in {
  options.JenSeReal.system.shells.fish = with types; {
    enable = mkEnableOption "Whether or not to use fish as a shell.";
  };

  config = mkIf cfg.enable {
    programs.fish.enable = true;
    environment.shells = with pkgs; [ fish ];
  };
}
