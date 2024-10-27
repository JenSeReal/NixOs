{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.types) package mkOpt;
  cfg = config.JenSeReal.nix;
  users = [
    "root"
    config.JenSeReal.user.name
  ];
in
{
  options.JenSeReal.nix = {
    enable = mkEnableOption "Whether or not to manage nix configuration.";
    package = mkOpt package pkgs.nix "Which nix package to use.";
  };

  config = mkIf cfg.enable {
    services.nix-daemon.enable = true;

    nix = {
      package = cfg.package;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        warn-dirty = false;
        http-connections = 50;
        log-lines = 50;
        sandbox = false;
        auto-optimise-store = false;
        allow-import-from-derivation = true;
        trusted-users = users;
        allowed-users = users;
        extra-nix-path = "nixpkgs=flake:nixpkgs";
        build-users-group = "nixbld";
      };
      extraOptions = ''
        warn-dirty = false
      '';
      gc = {
        automatic = true;
        interval = {
          Day = 7;
        };
        options = "--delete-older-than 2d";
        user = config.JenSeReal.user.name;
      };
    };
    nixpkgs.config.allowUnfree = true;
  };
}
