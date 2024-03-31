{ lib, config, pkgs, ... }:
with lib;
with lib.JenSeReal;

let
  cfg = config.JenSeReal.user;

  is-darwin = pkgs.stdenv.isDarwin;

  home-directory = if cfg.name == null then
    null
  else if is-darwin then
    "/Users/${cfg.name}"
  else
    "/home/${cfg.name}";
in {
  options.JenSeReal.user = {
    enable = mkEnableOption "Whether to configure the user account.";
    name = mkOpt (types.nullOr types.str) config.JenSeReal.user.name
      "The user account.";

    fullName = mkOpt types.str "Jens Plüddemann" "The full name of the user.";
    email = mkOpt types.str "jens@plueddemann.de" "The email of the user.";

    home = mkOpt (types.nullOr types.str) home-directory
      "The user's home directory.";
  };

  config = mkIf cfg.enable (mkMerge [{
    assertions = [
      {
        assertion = cfg.name != null;
        message = "JenSeReal.user.name must be set";
      }
      {
        assertion = cfg.home != null;
        message = "JenSeReal.user.home must be set";
      }
    ];

    home = {
      username = mkDefault cfg.name;
      homeDirectory = mkDefault cfg.home;
    };
  }]);
}
