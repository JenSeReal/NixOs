{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;

let
  cfg = config.JenSeReal.system.font;
  default = with pkgs; [
    cascadia-code
    google-fonts
    nerdfonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    fira-code
    fira-code-symbols
  ];
in {
  options.JenSeReal.system.font = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    default = mkOpt (listOf package) default "The default fonts to install";
    additional = mkOpt (listOf package) [ ] "Custom font packages to install.";
  };

  config = mkIf cfg.enable {
    environment.variables = { LOG_ICONS = "true"; };
    fonts.fontDir = enabled;
  };
}
