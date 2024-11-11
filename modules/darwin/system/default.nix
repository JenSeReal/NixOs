{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.types) int;
  inherit (lib.${namespace}) mkBoolOpt mkOpt enabled;

  cfg = config.${namespace}.system;
in
{
  options.${namespace}.system = {
    enable = mkBoolOpt true "Wether to enable custom system stuff.";
    stateVersion = mkOpt int 5 "The version of the state to use.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      direnv
      nix-direnv
      jq
    ];

    ${namespace}.system = {
      input = {
        fingerprint = enabled;
        keyboard = enabled;
        mouse = enabled;
        touchpad = enabled;
      };

      nix = enabled;

      power = enabled;

      shells = {
        bash = enabled;
        fish = enabled;
        nu = enabled;
        zsh = enabled;
      };
    };

    system = {
      defaults.smb.NetBIOSName = config.networking.hostName;
      activationScripts.postUserActivation.text = ''
        # activateSettings -u will reload the settings from the database and apply them to the current session,
        # so we do not need to logout and login again to make the changes take effect.
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
    };

    system.stateVersion = cfg.stateVersion;
  };
}
