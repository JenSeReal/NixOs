{ config, lib, inputs, ... }:
with lib;
with lib.JenSeReal;

let
  inherit (inputs) sops-nix;

  cfg = config.JenSeReal.security.sops;
in {
  imports = [ sops-nix.homeManagerModules.sops ];

  options.JenSeReal.security.sops = with types; {
    enable = mkBoolOpt false "Whether to enable sops.";
    defaultSopsFile = mkOpt path null "Default sops file.";
    sshKeyPaths = mkOpt (listOf path) [ ] "SSH Key paths to use.";
  };

  config = mkIf cfg.enable {
    sops = {
      inherit (cfg) defaultSopsFile;
      defaultSopsFormat = "yaml";

      age = {
        generateKey = true;
        keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ]
          ++ cfg.sshKeyPaths;
      };
    };

    home.activation.setupEtc = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      /run/current-system/sw/bin/systemctl start --user sops-nix
    '';
  };
}
