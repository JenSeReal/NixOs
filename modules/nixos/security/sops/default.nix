{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;
let cfg = config.JenSeReal.security.sops;
in {
  options.JenSeReal.security.sops = with types; {
    enable = mkEnableOption "Whether to enable sops.";
    defaultSopsFile = mkOpt path null "Default sops file.";
    sshKeyPaths = mkOpt (listOf path) [ "/etc/ssh/ssh_host_ed25519_key" ]
      "SSH Key paths to use.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ age sops ssh-to-age ];

    sops = {
      inherit (cfg) defaultSopsFile;

      age = {
        generateKey = true;
        keyFile = "/var/lib/sops-nix/key.txt";
        inherit (cfg) sshKeyPaths;
      };
    };
  };
}
