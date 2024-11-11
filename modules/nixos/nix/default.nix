{ config, lib, ... }:

with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.nix;

in {
  options.JenSeReal.nix = with types; {
    enable = mkEnableOption "Whether or not to enable additional cursors.";
  };

  config = mkIf cfg.enable {
    nix = {
      extraOptions = ''
        warn-dirty = false
      '';
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 2d";
      };
      optimise.automatic = true;

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [ "@wheel" ];
      };
    };
  };
}
