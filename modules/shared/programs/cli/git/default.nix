{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;

let cfg = config.JenSeReal.programs.cli.git;
in {
  options.JenSeReal.programs.cli.git = {
    enable = mkEnableOption "Whether or not to install and configure git.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bfg-repo-cleaner
      git
      git-crypt
      git-filter-repo
      git-lfs
      gitleaks
      gitlint
    ];
  };
}
