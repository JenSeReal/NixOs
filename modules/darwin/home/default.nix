{ options, config, lib, inputs, pkgs, ... }:
with lib;
with lib.JenSeReal;
let user = config.JenSeReal.user.name;
in {
  options.JenSeReal.home = with types; {
    file = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
    homeConfig = mkOpt attrs { } "Final config for home-manager.";
  };

  config = {
    JenSeReal.home.extraOptions = {
      home.stateVersion = mkDefault config.system.stateVersion;
      home.file = mkAliasDefinitions options.JenSeReal.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.JenSeReal.home.configFile;
    };

    JenSeReal.user.${user}.home.config =
      mkAliasDefinitions options.JenSeReal.home.extraOptions;

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      users.${user} = { lib, ... }: {
        home.activation = {
          trampolineApps = let
            mac-app-util =
              inputs.mac-app-util.packages.${pkgs.stdenv.system}.default;
          in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            fromDir="$HOME/Applications/Home Manager Apps"
            toDir="$HOME/Applications/Home Manager Trampolines"
            ${mac-app-util}/bin/mac-app-util sync-trampolines "$fromDir" "$toDir"
          '';
        };
      };
    };
  };
}
