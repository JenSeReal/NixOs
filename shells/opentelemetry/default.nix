{ pkgs, inputs, ... }:
let
  setupScript = pkgs.writeShellScriptBin "setup-env" "\n";
in
inputs.devenv.lib.mkShell {
  inherit inputs pkgs;
  modules = [
    {
      name = "OpenTelemetry development shell";
      dotenv.disableHint = true;

      languages = {
        nix.enable = true;
        nix.lsp.package = pkgs.nixd;

        javascript.enable = true;
        javascript.package = pkgs.nodePackages_latest.nodejs;
        javascript.pnpm.enable = true;
        javascript.yarn.enable = true;
        typescript.enable = true;

        python = {
          enable = true;
          package = pkgs.python313Full;
          venv.enable = true;
          venv.requirements = '''';
          libraries = with pkgs; [ python313Packages.pip ];
        };
      };

      packages =
        with pkgs;
        [
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

      enterShell = ''
        [ ! -f .env ] || export $(grep -v '^#' .env | xargs)
        ${setupScript}/bin/setup-env
      '';
    }
  ];
}
