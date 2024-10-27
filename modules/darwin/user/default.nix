{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:

let
  inherit (lib) types mkIf;
  inherit (lib.${namespace}) mkOpt;
  inherit (types) str nullOr int;
  cfg = config.JenSeReal.user;
in
{
  options.JenSeReal.user = {
    name = mkOpt str "jpl" "The user account.";

    fullName = mkOpt str "Jens Plüddemann" "The full name of the user.";
    email = mkOpt str "jens.plueddemann@novatec-gmbh.de" "The email of the user.";

    uid = mkOpt (nullOr int) 502 "The uid for the user account.";
  };

  config = {
    users.users.${cfg.name} = {
      uid = mkIf (cfg.uid != null) cfg.uid;
      shell = pkgs.zsh;
    };

    users.groups.docker = {
      name = "docker";
      members = "jpl";
    };
  };
}
