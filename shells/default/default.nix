{ pkgs, inputs, ... }:

let
  setupScript = pkgs.writeShellScriptBin "setup-env" ''
    [ ! -f .env ] || export $(grep -v '^#' .env | xargs);
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
        with pkgs;
        [
          hydra-check
          nix-diff
          nix-index
          nix-prefetch-git
          nixfmt-rfc-style
          nixpkgs-hammering
          nixpkgs-lint
          snowfallorg.flake
          snowfallorg.frost
          biome
        ]
        ++ lib.optionals stdenv.isDarwin (
          with darwin.apple_sdk.frameworks;
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
