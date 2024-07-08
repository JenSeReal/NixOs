{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.system.shells.addons.caraspace;
in
{
  options.JenSeReal.system.shells.addons.caraspace = with types; {
    enable = mkEnableOption "Whether or not to use caraspace completion.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ caraspace ]; };
}
