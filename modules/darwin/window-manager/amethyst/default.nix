{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.window-manager.amethyst;
in {
  options.JenSeReal.window-manager.amethyst = {
    enable = mkEnableOption "Enable amethyst";
  };

  config = mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [ "amethyst" ];
    };

    JenSeReal.home.configFile."amethyst/amethyst.yml".source = ./amethyst.yml;
  };
}
