{ config, lib, pkgs, inputs, system, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.programs.gui.ide.vscode;
  is-darwin = pkgs.stdenv.isDarwin;

  extensions = inputs.nix-vscode-extensions.extensions.${system};

  vscodePname = config.programs.vscode.package.pname;

  configDir = {
    "vscode" = "Code";
    "vscode-insiders" = "Code - Insiders";
    "vscodium" = "VSCodium";
  }.${vscodePname};

  userDir = if is-darwin then
    "Library/Application Support/${configDir}/User"
  else
    "${config.xdg.configHome}/${configDir}/User";

  configFilePath = "${userDir}/settings.json";
  # keybindingsFilePath = "${userDir}/keybindings.json";

  pathsToMakeWritable = lib.flatten [ configFilePath ];
in {
  options.JenSeReal.programs.gui.ide.vscode = {
    enable = mkEnableOption "Whether or not to enable vs code.";
  };

  imports = [
    "${
      fetchTarball {
        url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
        sha256 = "1rq8mrlmbzpcbv9ys0x88alw30ks70jlmvnfr2j8v830yy5wvw7h";
      }
    }/modules/vscode-server/home.nix"
    ./mutable.nix
  ];

  config = mkIf cfg.enable {
    services.vscode-server.enable = true;
    programs.vscode = {
      enable = true;

      userSettings = {
        "html.autoClosingTags" = true;
        "javascript.autoClosingTags" = true;
        "typescript.autoClosingTags" = true;

        "javascript.suggest.autoImports" = true;
        "typescript.suggest.autoImports" = true;
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "typescript.updateImportsOnFileMove.enabled" = "always";

        "javascript.preferences.renameMatchingJsxTags" = true;
        "typescript.preferences.renameMatchingJsxTags" = true;

        "css.format.enable" = true;
        "css.format.newlineBetweenRules" = true;
        "css.format.newlineBetweenSelectors" = true;
        "css.format.spaceAroundSelectorSeparator" = true;

        "yaml.format.enable" = true;
        "yaml.extension.recommendations" = false;

        "kotlin.languageServer.path" = "\${env:KOTLIN-LSP}";

        "[json][jsonc]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = true;
        };

        "[javascript][javascriptreact][typescript]" = {
          "editor.defaultFormatter" = "biomejs.biome";
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = true;
        };
        "[html][css][scss][less]" = {
          "editor.defaultFormatter" = "vscode.css-language-features";
        };

        "[nix][toml][rust][adoc][markdown][yaml]" = {
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = true;
        };

        "[typst]" = {
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
          "editor.autoClosingBrackets" = "always";
          "editor.autoClosingQuotes" = "always";
          "editor.defaultFormatter" = "nvarner.typst-lsp";
        };

        "[java][gradle]" = {
          "spotlessGradle.diagnostics.enable" = true;
          "spotlessGradle.format.enable" = true;
          "editor.defaultFormatter" = "richardwillis.vscode-spotless-gradle";
          "editor.codeActionsOnSave" = {
            "source.fixAll.spotlessGradle" = true;
          };
        };

        "[kotlin][gradle-kotlin-dsl]" = {
          "editor.defaultFormatter" = "cstef.kotlin-formatter";
          "spotlessGradle.diagnostics.enable" = true;
          "spotlessGradle.format.enable" = true;
          "editor.codeActionsOnSave" = {
            "source.fixAll.spotlessGradle" = true;
          };
        };

        "editor.fontFamily" = lib.mkDefault "Fira Code";
        "editor.bracketPairColorization.enabled" = true;
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "editor.fontLigatures" = true;
        "editor.linkedEditing" = true;
        "editor.codeActionsOnSave" = {
          "source.addMissingImports" = true;
          "source.organizeImports" = true;
          "source.sortImports" = true;
          "source.fixAll" = true;
          "quickfix.biome" = true;
          "source.organizeImports.biome" = true;
        };
        "editor.inlayHints.enabled" = "on";

        "files.trimTrailingWhitespace" = true;

        "indentRainbow.indicatorStyle" = "light";
        "indentRainbow.lightIndicatorStyleLineWidth" = 1;
        "indentRainbow.colors" = [
          "rgba(255,255,64,0.3)"
          "rgba(127,255,127,0.3)"
          "rgba(255,127,255,0.3)"
          "rgba(79,236,236,0.3)"
        ];

        "keyboard.dispatch" = "keyCode";

        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "nixfmt";
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          "nil" = { "formatting" = { "command" = [ "nixfmt" ]; }; };
        };

        "remote.SSH.useLocalServer" = false;

        "telemetry.telemetryLevel" = "all";
        "terminal.integrated.fontFamily" = mkDefault "Fira Code";
        "typst-lsp.experimentalFormatterMode" = "on";

        "vsicons.dontShowNewVersionMessage" = true;

        "window.titleBarStyle" = "custom";
        "window.menuBarVisibility" = mkIf (!is-darwin) "toggle";
        "window.commandCenter" = false;

        "workbench.colorTheme" = mkDefault "SynthWave '84";
        "workbench.startupEditor" = "none";
        "workbench.sideBar.location" = "right";
        "workbench.layoutControl.enabled" = false;
        "workbench.iconTheme" = "vscode-icons";
      };

      extensions = with extensions.vscode-marketplace;
        [
          yzhang.markdown-all-in-one
          asciidoctor.asciidoctor-vscode
          tamasfe.even-better-toml
          redhat.vscode-yaml
          ms-azuretools.vscode-docker
          usernamehw.errorlens
          shardulm94.trailing-spaces
          christian-kohler.path-intellisense
          vscode-icons-team.vscode-icons
          redhat.vscode-xml
          oderwat.indent-rainbow
          rust-lang.rust-analyzer
          serayuzgur.crates
          vadimcn.vscode-lldb
          pflannery.vscode-versionlens
          lorenzopirro.rust-flash-snippets
          zhangyue.rust-mod-generator
          jedeop.crates-completer
          jscearcy.rust-doc-viewer
          biomejs.biome
          rangav.vscode-thunder-client
          dotjoshjohnson.xml
          jgclark.vscode-todo-highlight
          gruntfuggly.todo-tree
          chrmarti.regex
          aaron-bond.better-comments
          ms-vsliveshare.vsliveshare
          pinage404.nix-extension-pack
          robbowen.synthwave-vscode
          ms-vscode-remote.vscode-remote-extensionpack
          formulahendry.docker-explorer
          redhat.java
          vscjava.vscode-java-test
          vscjava.vscode-java-debug
          vscjava.vscode-maven
          vscjava.vscode-java-dependency
          vscjava.vscode-spring-initializr
          # vscjava.vscode-gradle
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ ];

      keybindings = [ ];
    };

    home.file = lib.genAttrs pathsToMakeWritable (_: {
      force = true;
      mutable = true;
    });
  };
}
