{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.theming.stylix;
in
{
  options.JenSeReal.theming.stylix = {
    enable = mkEnableOption "Whether or not to enable stylix theming.";
  };

  config = mkIf cfg.enable {
    # stylix.image = ./2.jpg;
    # stylix.polarity = "dark";
    # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/paraiso.yaml";

    # stylix.fonts.monospace = with pkgs; {
    #   name = "Fira Code";
    #   package = fira-code;
    # };

    # stylix.targets.xfce.enable = false;
    # stylix.targets.vscode.enable = false;
    # stylix.targets.hyprland.enable = false;
  };
}
