{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;

let cfg = config.JenSeReal.system.boot;
in {
  options.JenSeReal.system.boot = {
    enable = mkEnableOption "Whether or not to enable booting.";
    plymouth = mkEnableOption "Whether or not to enable plymouth boot splash.";
    secure-boot = mkEnableOption "Whether or not to enable secure boot.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [ efibootmgr efitools efivar fwupd ]
      ++ lib.optionals cfg.secure-boot [ sbctl ];

    boot = {
      bootspec.enable = true;
      consoleLogLevel = 0;
      initrd.verbose = false;
      supportedFilesystems = [ "btrfs" "ntfs" "fat32" ];
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = lib.optionals cfg.plymouth [
        "quiet"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "boot.shell_on_fail"
      ];

      lanzaboote = mkIf cfg.secure-boot {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };

      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };

        systemd-boot = {
          enable = !cfg.secure-boot;
          configurationLimit = 20;
          editor = false;
        };
      };

      plymouth = mkIf cfg.secure-boot {
        enable = true;
        theme = "catppuccin-macchiato";
        themePackages = [ pkgs.catppuccin-plymouth ];
      };
    };
    security.tpm2.enable = true;
    security.tpm2.tctiEnvironment.enable = true;

    services.fwupd.enable = true;
  };
}
