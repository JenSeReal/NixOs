{
  options,
  config,
  lib,
  inputs,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types mkDefault mkAliasDefinitions;
  user = config.${namespace}.user.name;
in
{
  options.${namespace}.home = with types; {
    file = mkOpt attrs { } "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile =
      mkOpt attrs { }
        "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
    homeConfig = mkOpt attrs { } "Final config for home-manager.";
  };

  config = {
    JenSeReal.home.extraOptions = {
      home.stateVersion = mkDefault config.system.stateVersion;
      home.file = mkAliasDefinitions options.${namespace}.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.${namespace}.home.configFile;
    };

    snowfallorg.users.${user}.home.config =
      lib.mkAliasDefinitions
        options.${namespace}.home.extraOptions;

    home-manager = {
      backupFileExtension = "hm.old";
      useUserPackages = true;
      useGlobalPkgs = true;
      users.${user} =
        { lib, ... }:
        {
          home.activation = {
            trampolineApps =
              let
                mac-app-util = inputs.mac-app-util.packages.${pkgs.stdenv.system}.default;
              in
              lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                fromDir="$HOME/Applications/Home Manager Apps"
                toDir="$HOME/Applications/Home Manager Trampolines"
                ${mac-app-util}/bin/mac-app-util sync-trampolines "$fromDir" "$toDir"
              '';
          };
        };
    };
  };
}
