{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.types) listOf str;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.JenSeReal.cli.homebrew;
  user = config.JenSeReal.user;
in
{
  options.JenSeReal.cli.homebrew = {
    enable = mkEnableOption "Wether to enable homebrew.";
    additional_brews = mkOpt (listOf str) [ ] "A list of additional brews to install";
    additional_casks = mkOpt (listOf str) [ ] "A list of additional casks to install";
  };

  config = mkIf cfg.enable {
    nix-homebrew = {
      enable = true;
      user = user.name;
    };
    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "uninstall";
        autoUpdate = true;
        upgrade = true;
      };
      global.autoUpdate = true;
      casks = [
        "iina"
        "miro"
        "steam"
        "homebrew/cask-versions/virtualbox-beta"
        "logseq"
        "chromium"
        {
          name = "middleclick";
          args = {
            no_quarantine = true;
          };
        }
        "headlamp"
      ] ++ cfg.additional_casks;
    };
  };
}
