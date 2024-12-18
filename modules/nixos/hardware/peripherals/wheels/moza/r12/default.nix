{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.hardware.peripherals.wheels.moza.r12;

in
{
  options.${namespace}.hardware.peripherals.wheels.moza.r12 = {
    enable = mkEnableOption "Whether or not to enable Moza R12.";
  };
  config = mkIf cfg.enable {
    boot = {
      extraModulePackages = [
        pkgs.${namespace}.universal-pidff
        # config.boot.kernelPackages.universal-pidff
      ];
    };
    environment.systemPackages = [
      pkgs.${namespace}.boxflat
      pkgs.linuxConsoleTools
      # pkgs.${namespace}.ffb-tools
    ];
    services.udev.packages = [ pkgs.${namespace}.boxflat ];
  };
}
