{
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.cli.git;
in
{
  imports = [ (lib.snowfall.fs.get-file "modules/common/programs/cli/git/default.nix") ];

  config = mkIf cfg.enable { };
}
