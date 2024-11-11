{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption getExe;

  cfg = config.JenSeReal.virtualisation.docker;
in
{
  options.JenSeReal.virtualisation.docker = {
    enable = mkEnableOption "Wether to enable docker.";
  };

  config = mkIf cfg.enable {
    JenSeReal.programs.cli.homebrew = {
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

      kubectl

      colima

      docker
      docker-credential-helpers

      podman
      podman-compose
      podman-tui
    ];

    users.groups.docker = {
      name = "docker";
      members = config.${namespace}.user.name;
    };

    launchd.user.agents.colima.serviceConfig = {
      Program = "${getExe pkgs.colima}";
      ProgramArguments = [
        "start"
        "--cpu"
        "8"
        "--memory"
        "16"
        "--kubernetes"
      ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
