{
  pkgs,
  inputs,
  stdenv,
  ...
}:

let
  setupScript = pkgs.writeShellScriptBin "setup-env" ''
    [ ! -f .env ] || export $(grep -v '^#' .env | xargs)
    cargo install cargo-watch
    cargo install cargo-edit
    cargo install cargo-update
  '';

in
inputs.devenv.lib.mkShell {
  inherit inputs pkgs;
  modules = [
    (
      { pkgs, ... }:
      {
        name = "Rust AoC dev shell";
        dotenv.disableHint = true;
        languages = {
          nix.enable = true;
          nix.lsp.package = pkgs.nixd;
          rust.enable = true;
        };

        env.LIBCLANG_PATH = pkgs.lib.makeLibraryPath [ pkgs.llvmPackages_latest.libclang.lib ];
        env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ stdenv.cc.cc.lib ];

        packages =
          with pkgs stdenv;
          [
            nushell
            llvm
            clang
            openssl
          ]
          ++ lib.optionals isDarwin (
            with darwin.apple_sdk.frameworks;
            [
              Cocoa
              CoreServices
              CoreServices
              Security
            ]
          );

        enterShell = "${setupScript}/bin/setup-env";
      }
    )
  ];
}
