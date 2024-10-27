{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.JenSeReal.virtualisation.docker;
in
{
  options.JenSeReal.virtualisation.docker = {
    enable = mkEnableOption "Wether to enable docker.";
  };

  config = mkIf cfg.enable {
    JenSeReal.cli.homebrew = {
      enable = true;
      additional_casks = [
        "podman-desktop"
        "rancher"
      ];
      additional_brews = [
        "lxc"
        "rancher-cli"
      ];
    };

    environment.systemPackages = with pkgs; [
      qemu
      # libvirt
      # virt-manager

      colima

      kind
      minikube

      docker
      docker-credential-helpers

      podman
      podman-compose
      podman-tui
    ];
  };
}
