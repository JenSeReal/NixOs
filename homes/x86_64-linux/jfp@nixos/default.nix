{ lib, config, ... }:
with lib;
with lib.JenSeReal; {
  JenSeReal = {
    programs = {
      cli = {
        git = enabled;
        ssh = {
          enable = true;
          includes = [ "${config.home.homeDirectory}/.ssh/hosts/jfp.one" ];
        };
      };
      gui.terminal-emulator.kitty = enabled;
    };
    security.sops = enabled;
  };

  sops.secrets."ssh/jfp.one" = {
    sopsFile = ./secrets/ssh.yml;
    path = "${config.home.homeDirectory}/.ssh/hosts/jfp.one";
  };

  nix.extraOptions = "";
}
