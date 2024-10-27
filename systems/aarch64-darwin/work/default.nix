{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vscode
    direnv
    nix-direnv
    git
    lazygit
    pciutils
    eza
    bat
    fd
    du-dust
    delta
    rm-improved
    ripgrep
    fzf
    zoxide
    killall
    btop
    cyberchef
    discord
    wget
    jetbrains.idea-community-bin
    gimp
    inkscape
    act
    postman
    ollama
    devenv
    seabird
  ];

  JenSeReal.cli.homebrew.enable = true;
  JenSeReal.entertainment.music.spotify.enable = true;
  JenSeReal.security.enable = true;
  JenSeReal.system.enable = true;
  JenSeReal.system.font.enable = true;
  JenSeReal.system.mouse.enable = true;
  JenSeReal.system.shells.nushell.enable = true;
  JenSeReal.system.shells.fish.enable = true;
  JenSeReal.system.shells.addons.starship.enable = true;
  JenSeReal.system.touchpad.enable = true;
  JenSeReal.desktop.launcher.raycast.enable = true;
  JenSeReal.desktop-environment.aerospace.enable = true;
  JenSeReal.gui.browser.arc.enable = true;
  JenSeReal.virtualisation.docker.enable = true;

  system.stateVersion = 5;
}
