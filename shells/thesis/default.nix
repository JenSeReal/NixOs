{ pkgs, inputs, ... }:

let
  setupScript = pkgs.writeShellScriptBin "setup" ''
    cargo install hayagriva --features cli
  '';
  startScript = pkgs.writeShellScriptBin "start-typst-live" ''
    rm -rf output.pdf
    exec typst-live src/main.typ
  '';
  convertBibScript = pkgs.writeShellScriptBin "convert" ''
    hayagriva temp.bib > temp.yml
  '';

  mkShell = inputs.devenv.lib.mkShell;

in
mkShell {
  inherit inputs pkgs;

  modules = [
    (
      { pkgs, ... }:
      {
        name = "Thesis shell";
        languages.rust.enable = true;

        scripts.run.exec = "${startScript}/bin/start-typst-live";
        scripts.convert.exec = "${convertBibScript}/bin/convert";
        packages =
          with pkgs;
          [
            typst
            typstfmt
            typst-live
            typst-preview
            typst-lsp
            vscode-extensions.nvarner.typst-lsp
          ]
          ++ lib.optionals stdenv.isDarwin (
            with darwin.apple_sdk.frameworks;
            [
              Cocoa
              CoreServices
              CoreFoundation
              Security
            ]
          );

        enterShell = ''
          ${setupScript}/bin/setup
        '';
      }
    )
  ];
}
