{ channels, ... }:
final: prev: {
  inherit (channels.unstable) wine wineWowPackages;
}

