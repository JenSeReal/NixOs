{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  setupScript = pkgs.writeShellScriptBin "setup-env" ''
    [ ! -f .env ] || export $(grep -v '^#' .env | xargs);
    ${lib.getExe pkgs.biome} start
  '';
in
inputs.devenv.lib.mkShell {
  inherit inputs pkgs;

  modules = [
    {
      name = "Basic development shell";
      dotenv.disableHint = true;

      languages = {
        nix.enable = true;
        nix.lsp.package = pkgs.nixd;
      };

      packages =
        [
          pkgs.hydra-check
          pkgs.nix-diff
          pkgs.nix-index
          pkgs.nix-prefetch-git
          pkgs.nixfmt-rfc-style
          pkgs.nixpkgs-hammering
          pkgs.nixpkgs-lint
          pkgs.snowfallorg.flake
          pkgs.snowfallorg.frost
          pkgs.jemalloc
          pkgs.biome
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin (
          with pkgs.darwin.apple_sdk.frameworks;
          [
            Cocoa
            CoreFoundation
            CoreServices
            Security
          ]
        );

      enterShell = "${setupScript}/bin/setup-env";
    }
  ];
}
