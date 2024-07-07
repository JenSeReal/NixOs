{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.system.shells.addons.starship;
in
{
  options.JenSeReal.system.shells.addons.starship = {
    enable = mkEnableOption "Enable starship.";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red) ";
        };
        time = {
          disabled = false;
          format = "🕙[ $time ]($style)";
        };
        right_format = "$time";
      };
    };
  };
}
