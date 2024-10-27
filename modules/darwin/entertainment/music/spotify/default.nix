{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.entertainment.music.spotify;
in {
  options.JenSeReal.entertainment.music.spotify = { };

  imports = [ ../../../../shared/entertainment/music/spotify/default.nix ];

  config = mkIf cfg.enable { };
}
