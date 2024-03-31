{ lib, config, ... }:
with lib;
with lib.JenSeReal;

let cfg = config.JenSeReal.user;
in {
  options.JenSeReal.user = with types; {
    name = mkOpt str "jpl" "The user account.";

    fullName = mkOpt str "Jens Plüddemann" "The full name of the user.";
    email =
      mkOpt str "jens.plueddemann@novatec-gmbh.de" "The email of the user.";

    uid = mkOpt (nullOr int) 502 "The uid for the user account.";
  };

  config = {
    users.users.${cfg.name} = { uid = mkIf (cfg.uid != null) cfg.uid; };

    users.groups.docker = {
      name = "docker";
      members = "jpl";
    };
  };
}
