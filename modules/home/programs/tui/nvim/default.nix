{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.JenSeReal.tools.nvim;
in
{
  options.JenSeReal.tools.nvim = {
    enable = mkEnableOption "Whether or not to enable neovim.";
  };

  config = mkIf cfg.enable { programs.neovim.enable = true; };
}
