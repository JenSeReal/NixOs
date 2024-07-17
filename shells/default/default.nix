{ pkgs, mkShell, ... }:

mkShell {
  name = "Default nix devShell";
  buildInputs = with pkgs; [
    deadnix
    hydra-check
    nix-diff
    nix-index
    nix-prefetch-git
    nil
    nixd
    nixfmt-rfc-style
    nixpkgs-fmt
    nixpkgs-hammering
    nixpkgs-lint
    snowfallorg.flake
    snowfallorg.frost
    statix
    biome
  ];

  shellHook = ''
    echo Welcome to nix!
  '';
}
