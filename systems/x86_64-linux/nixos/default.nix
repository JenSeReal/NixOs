{ pkgs, lib, inputs, config, ... }:
with lib;
with lib.JenSeReal;

{
  imports = with inputs; [
    nixos-hardware.nixosModules.framework-13-7040-amd
    ./hardware-configuration.nix
  ];

  hardware.enableAllFirmware = true;

  #boot.extraModprobeConfig = '' options bluetooth disable_ertm=1 '';

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  users.users."jfp" = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ firefox freshfetch ];
  };

  services.fprintd.enable = true;

  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
    };
  };

  services.desktopManager.plasma6 = enabled;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "jfp";
  hardware.pulseaudio.enable = mkForce false;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  programs.gnupg.agent.pinentryPackage = mkForce pkgs.pinentry-qt;

  services.xserver.libinput.enable = true;

  services.printing.enable = true;

  security.pki.certificateFiles = [ ./T-TeleSec_GlobalRoot_Class_2.pem ];

  environment.systemPackages = with pkgs; [
    btop
    curl
    direnv
    nix-direnv
    fw-ectool
    webcord
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    hunspellDicts.de_DE
    onlyoffice-bin
  ];
  programs.nix-ld.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.sops.secrets."wifi.env".path ];
    profiles = {
      "FRITZ!Box 7590 EW" = {
        connection = {
          id = "FRITZ!Box 7590 EW";
          type = "wifi";
          interface-name = "wlp1s0";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "FRITZ!Box 7590 EW";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "$FRITZBox_7590_EW";
        };
        ipv4 = { method = "auto"; };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = { };
      };
      "FRITZ!Box 6690 BD" = {
        connection = {
          id = "FRITZ!Box 6690 BD";
          type = "wifi";
          interface-name = "wlp1s0";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "FRITZ!Box 6690 BD";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "$FRITZBox_6690_BD";
        };
        ipv4 = { method = "auto"; };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = { };
      };
      "PPP-Netz" = {
        connection = {
          id = "PPP-Netz";
          type = "wifi";
          interface-name = "wlp1s0";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "PPP-Netz";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "$PPPNetz";
        };
        ipv4 = { method = "auto"; };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = { };
      };
    };
  };

  JenSeReal = {
    entertainment.gaming = {
      lutris = enabled;
      steam = enabled;
    };
    hardware = {
      audio.pipewire = enabled;
      bluetooth = enabled;
      opengl = enabled;
    };
    nix = enabled;
    security = {
      bitwarden = enabled;
      gnupg = enabled;
      keyring = enabled;
      polkit = enabled;
      sops = {
        enable = true;
        defaultSopsFile = secrets/secrets.yml;
      };
    };
    services = { fwupd = enabled; };
    system = {
      boot = {
        enable = true;
        plymouth = true;
        secure-boot = true;
      };
      cursor = enabled;
      font = enabled;
      keyboard = enabled;
      locale = enabled;
      power-management = enabled;
      shells.nushell = enabled;
      shells.fish = enabled;
      shells.addons.starship = enabled;
      time = enabled;
    };
    programs = { cli = { git = enabled; }; };
  };

  sops.secrets."wifi.env" = { sopsFile = ../../shared/secrets/wifi.yml; };

  system.stateVersion = "23.11";
}
