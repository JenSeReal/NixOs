{ pkgs, lib, config, ... }:
with lib;
with lib.JenSeReal;
let
  is-darwin = pkgs.stdenv.isDarwin;
  user = config.JenSeReal.user;
in {
  programs.zsh = {
    enable = true;

    initExtra = mkIf is-darwin ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="/Users/jpl/.rd/bin:$PATH"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
    };
  };

  programs.git = {
    enable = true;
    userName = user.name;
    userEmail = user.email;
    lfs = enabled;
    extraConfig = {
      init = { defaultBranch = "main"; };
      pull = { rebase = true; };
      push = { autoSetupRemote = true; };
      core = { whitespace = "trailing-space,space-before-tab"; };
      safe = { directory = "${user.home}/dev"; };
    };
  };

  programs.gh = enabled;

  JenSeReal = {
    user = { enable = true; };
    cli = {
      bat.enable = true;
      eza.enable = true;
      fzf.enable = true;
      home-manager.enable = true;
      ripgrep.enable = true;
      zoxide.enable = true;
      thefuck.enable = true;
    };
    gui.ide.vscode.enable = true;
    tools.direnv.enable = true;
    desktop.terminal-emulator.kitty.enable = true;
    system.shells = {
      nushell.enable = true;
      fish.enable = true;
      addons.starship.enable = true;
    };
  };
}
