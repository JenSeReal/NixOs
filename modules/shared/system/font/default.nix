{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.types) listOf package;
  inherit (lib.${namespace}) mkOpt;

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
    dejavu_fonts
  ];
in
{
  options.JenSeReal.system.font = {
    enable = mkEnableOption "Whether or not to manage fonts.";
    additionalFonts = mkOpt (listOf package) [ ] "Custom font packages to install.";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      LOG_ICONS = "true";
    };
    fonts.packages = default ++ cfg.additionalFonts;
  };
}
