{ pkgs, inputs, ... }:

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
          deadnix
          hydra-check
          nix-diff
          nix-index
          nix-prefetch-git
          nixfmt-rfc-style
          nixpkgs-hammering
          nixpkgs-lint
          snowfallorg.flake
          snowfallorg.frost
          statix
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
      '';
    }
  ];
}

# { pkgs, mkShell, ... }:

# mkShell {
#   name = "Default nix devShell";
#   buildInputs = with pkgs; [
#     deadnix
#     hydra-check
#     nix-diff
#     nix-index
#     nix-prefetch-git
#     nil
#     nixd
#     nixfmt-rfc-style
#     nixpkgs-fmt
#     nixpkgs-hammering
#     nixpkgs-lint
#     snowfallorg.flake
#     snowfallorg.frost
#     statix
#     biome
#   ];

#   shellHook = ''
#     echo Welcome to nix!
#   '';
# }
