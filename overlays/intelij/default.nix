{ channels, ... }:
final: prev: { inherit (channels.nixpkgs-unstable) "jetbrains.idea-community-bin"; }
