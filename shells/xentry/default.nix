{
  pkgs,
  inputs,
  lib,
  channels,
  ...
}:
let
  setupScript = pkgs.writeShellScriptBin "setup-env" ''
    [ ! -f .env ] || export $(grep -v '^#' .env | xargs);
    ${lib.getExe pkgs.biome} start
  '';

  loginScript = pkgs.writeShellScriptBin "login" ''
    IdpCli configure-credentials --role $AWS_ROLE --account $AWS_ACCOUNT &&
    aws ssm start-session --target $1 --region eu-central-1
  '';

  localDevelopment = pkgs.writeShellScriptBin "local-dev" ''
    pnpx @datadog/datadog-ci synthetics run-tests --public-id igm-9nb-ycn --tunnel --override startUrl=http://localhost:9000
  '';
in
inputs.devenv.lib.mkShell {
  inherit inputs;
  pkgs = channels.nixpkgs-unstable;

  modules = [
    {
      name = "Xentry E2E-Monitoring development shell";
      dotenv.disableHint = true;

      languages = {
        javascript.enable = true;
        javascript.package = channels.nixpkgs-unstable.nodejs-slim_23;
        javascript.pnpm.enable = true;
        javascript.yarn.enable = true;
        typescript.enable = true;

        terraform.enable = true;
        opentofu.enable = true;

        python = {
          enable = true;
          package = pkgs.python312Full;
          venv.enable = true;
          venv.requirements = ''
            google-api-python-client
            google-auth-oauthlib
            google
          '';
          libraries = with pkgs; [ python312Packages.pip ];
        };
      };

      scripts.login.exec = ''${loginScript}/bin/login $@'';
      scripts.local-dev.exec = ''${localDevelopment}/bin/local-dev'';

      packages =
        [
          pkgs.jemalloc
          pkgs.biome
          pkgs.nixd
          pkgs.nixfmt-rfc-style
          pkgs.awscli2
          pkgs.ssm-session-manager-plugin
          pkgs.kubernetes-helm
          # pkgs.kubernetes-polaris
          pkgs.kubernetes-code-generator
          pkgs.helm-ls
          pkgs.k9s
          pkgs.kubectl
          pkgs.ktop
          pkgs.kubecolor
          pkgs.terraformer
          pkgs.terraforming
          pkgs.tflint
          pkgs.kubectx
          pkgs.kube-linter
          pkgs.helmfile
          pkgs.kompose
          pkgs.act
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

      enterShell = ''${setupScript}/bin/setup-env'';
    }
  ];
}
