{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;

let cfg = config.JenSeReal.security.bitwarden;
in {
  options.JenSeReal.security.bitwarden = with types; {
    enable = mkEnableOption "Whether to enable Bitwarden.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ bitwarden ]; };
}
