{ options, config, lib, ... }:

with lib;
with lib.JenSeReal; {
  options.JenSeReal.home = with types; {
    file = mkOpt attrs { }
      "A set of files to be managed by home-manager's `home.file`.";
    configFile = mkOpt attrs { }
      "A set of files to be managed by home-manager's `xdg.configFile`.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = {
    JenSeReal.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.JenSeReal.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.JenSeReal.home.configFile;
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.${config.JenSeReal.user.name} =
        mkAliasDefinitions options.JenSeReal.home.extraOptions;
    };
  };
}
