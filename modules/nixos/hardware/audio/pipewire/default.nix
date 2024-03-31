{ config, lib, pkgs, ... }:
with lib;
with lib.JenSeReal;

let cfg = config.JenSeReal.hardware.audio.pipewire;
in {
  options.JenSeReal.hardware.audio.pipewire = with types; {
    enable = mkEnableOption "Whether or not to enable pipewire.";
    extra-packages = mkOpt (listOf package) [ pkgs.qjackctl pkgs.easyeffects ]
      "Additional packages to install.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [ pulsemixer pavucontrol helvum ] ++ cfg.extra-packages;

    sound = enabled;
    hardware.pulseaudio = { package = pkgs.pulseaudioFull; };
    security.rtkit = enabled;

    services.pipewire = {
      enable = true;
      alsa = enabled;
      jack = enabled;
      pulse = enabled;
      wireplumber = enabled;
    };

    JenSeReal.user.extraGroups = [ "audio" ];
  };
}
