{ config, lib, pkgs, ... }:

with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.system.shells.nushell;
in {
  options.JenSeReal.system.shells.nushell = with types; {
    enable = mkEnableOption "Whether or not to use nuhsell as a shell.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nushell ];
    environment.shells = with pkgs; [ nushell ];
  };
}
