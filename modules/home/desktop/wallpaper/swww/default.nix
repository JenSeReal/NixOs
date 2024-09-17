{
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.desktop.wallpaper.swww;
in
{
  imports = [ ../../../../../packages/swww/default.nix ];

  options.${namespace}.desktop.wallpaper.swww = {
    enable = mkBoolOpt false "Whether to enable swww service.";
  };
  config = mkIf cfg.enable { services.swww.enable = true; };
}
