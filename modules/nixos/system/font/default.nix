{ config, pkgs, lib, ... }:
with lib;
with lib.JenSeReal;

let cfg = config.JenSeReal.system.font;
in {
  imports = [ ../../../shared/system/font/default.nix ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ font-manager fontpreview ];

    fonts.packages = cfg.default ++ cfg.additional;
  };
}
