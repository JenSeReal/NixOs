{
  pkgs,
  inputs,
  stdenv,
  lib,
  ...
}:
let
  setupScript = pkgs.writeShellScriptBin "setup-env" "\n";

in
inputs.devenv.lib.mkShell {
  inherit inputs pkgs;
  modules = [
    (
      { pkgs, ... }:
      {
        name = "dqualizer development shell";

        languages = {
          java = {
            enable = true;
            jdk.package = pkgs.jdk21;
            maven.enable = true;
            gradle.enable = true;
          };
          kotlin.enable = true;
        };

        packages =
          with lib pkgs stdenv;
          [
            nushell
            nodePackages_latest.nodejs
            biome
            kotlin-language-server
            ktfmt
            ktlint
          ]
          ++ optionals isDarwin (
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
    )
  ];
}
