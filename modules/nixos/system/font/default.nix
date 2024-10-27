{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.JenSeReal.system.font;
in
{
  imports = [ ../../../shared/system/font/default.nix ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      font-manager
      fontpreview
    ];
    fonts.fontDir.enable = true;
  };
}
