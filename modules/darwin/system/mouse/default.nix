{ config, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.JenSeReal.system.mouse;
in
{
  options.JenSeReal.system.mouse = {
    enable = mkEnableOption "Whether or not to manage mouse settings.";
  };

  config = mkIf cfg.enable {
    JenSeReal.cli.homebrew = {
      enable = true;
      additional_casks = [ "unnaturalscrollwheels" ];
    };
  };
}
