{
  config,
  lib,
  namespace,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled;
  is-darwin = pkgs.stdenv.isDarwin;
in
{
  imports = [ inputs.ragenix.homeManagerModules.default ];

  age.secrets.ssh-config-jfp-one = {
    file = ./secrets/ssh-config-jfp-one.age;
    path = "${config.home.homeDirectory}/.ssh/includes/ssh-config-jfp-one";
  };

  programs.zsh = {
    enable = true;

    initExtra = mkIf is-darwin ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="/Users/jpl/.rd/bin:$PATH"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "thefuck"
      ];
    };
  };

  JenSeReal = {
    programs = {
      cli = {
        bat = enabled;
        direnv = enabled;
        eza = enabled;
        fzf = enabled;
        git = enabled;
        ripgrep = enabled;
        ssh = {
          enable = true;
          includes = [ (lib.removePrefix ".ssh/" config.age.secrets.ssh-config-jfp-one.path) ];
        };
        thefuck = enabled;
        zoxide = enabled;
      };

      gui = {
        ide.vscode = enabled;
        terminal-emulators.wezterm = enabled;
      };

      tui.nvim = enabled;

      shells = {
        nushell = enabled;
        fish = enabled;
        addons.starship = enabled;
        addons.carapace = enabled;
      };
    };

    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };
  };

  home.stateVersion = "24.05";
}
