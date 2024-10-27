{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.gui.browser.arc;
in {
  options.JenSeReal.gui.browser.arc = with types; {
    enable = mkEnableOption "Wether to enable arc.";
  };

  config = mkIf cfg.enable {
    JenSeReal.cli.homebrew = {
      enable = true;
      additional_casks = [ "arc" ];
    };
  };
}
