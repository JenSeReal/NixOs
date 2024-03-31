{ config, lib, ... }:

with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.security.gnupg;

in {
  options.JenSeReal.security.gnupg = with types; {
    enable = mkEnableOption "Whether or not to enable additional cursors.";
  };

  config = mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
