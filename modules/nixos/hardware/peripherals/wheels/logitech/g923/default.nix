{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.hardware.peripherals.wheels.logitech.g923;
in
{
  options.${namespace}.hardware.peripherals.wheels.logitech.g923 = {
    enable = mkEnableOption "Whether or not to enable Logitech G923";
  };

  config = mkIf cfg.enable {

    # hardware.new-lg4ff.enable = true;

    boot = {
      extraModulePackages = [ pkgs.${namespace}.new-lg4ff ];
      kernelModules = [ "hid-logitech-new" ];
    };

    services.udev.packages = with pkgs; [ oversteer ];
    environment.systemPackages = [ pkgs.oversteer ];
  };
}
