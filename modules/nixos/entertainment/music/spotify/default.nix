{ config, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.JenSeReal.system.font;
in
{
  imports = [ ../../../../shared/entertainment/music/spotify/default.nix ];

  config = mkIf cfg.enable { };
}
