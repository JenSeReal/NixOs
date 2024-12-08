{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.nix;

in
{
  options.JenSeReal.nix = {
    enable = mkEnableOption "Whether or not to enable additional nix config.";
  };

  config = mkIf cfg.enable {
    nix = {
      extraOptions = ''
        warn-dirty = false
      '';
      gc = {
        dates = "weekly";
      };

      optimise = {
        automatic = true;
        dates = [ "weekly" ];
      };

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [ "@wheel" ];
      };
    };
  };
}
