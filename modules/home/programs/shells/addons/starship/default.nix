{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.JenSeReal.programs.shells.addons.starship;
in
{
  options.JenSeReal.programs.shells.addons.starship = {
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
          format = ''🕙[$time]($style)'';
        };
        right_format = "$time";
      };
    };
  };
}
