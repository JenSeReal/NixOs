{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;

let cfg = config.JenSeReal.hardware.bluetooth;
in {
  options.JenSeReal.hardware.bluetooth = with types; {
    enable = mkEnableOption "Whether or not to enable bluetooth.";
  };

  config = mkIf cfg.enable {
    JenSeReal.hardware.audio.pipewire.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;

    systemd.user.services.mpris-proxy = {
      description = "Mpris proxy";
      after = [ "network.target" "sound.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };

    hardware.bluetooth.settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };

    hardware.pulseaudio.extraConfig = "load-module module-switch-on-connect";
  };
}
