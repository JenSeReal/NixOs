{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    concatStringsSep
    concatMap
    ;
  inherit (lib.${namespace}) enabled;

  modifierKey = "ctrl";

  workspaces = [
    {
      key = "1";
      name = "internet";
      apps = [ "org.mozilla.firefox" ];
    }
    {
      key = "2";
      name = "code";
      apps = [ "com.microsoft.VSCode" ];
    }
    {
      key = "3";
      name = "terminal";
      apps = [
        "com.apple.Terminal"
        "net.kovidgoyal.kitty"
      ];
    }
    {
      key = "4";
      name = "productive";
      apps = [ "com.electron.realtimeboard" ];
    }
    {
      key = "5";
      name = "5";
      apps = [ ];
    }
    {
      key = "6";
      name = "6";
      apps = [ ];
    }
    {
      key = "7";
      name = "notes";
      apps = [
        "com.microsoft.onenote.mac"
        "com.electron.logseq"
      ];
    }
    {
      key = "8";
      name = "utils";
      apps = [ "com.spotify.client" ];
    }
    {
      key = "9";
      name = "chat";
      apps = [
        "com.tinyspeck.slackmacgap"
        "com.microsoft.Outlook"
      ];
    }
    {
      key = "0";
      name = "conference";
      apps = [
        "com.microsoft.teams2"
        "us.zoom.xos"
      ];
    }
  ];

  directions = [
    {
      key = "h";
      direction = "left";

    }
    {
      key = "j";
      direction = "down";

    }
    {
      key = "k";
      direction = "up";

    }
    {
      key = "l";
      direction = "right";

    }
  ];

  floating_windows = [
    "com.apple.systempreferences"
    "org.openvpn.client.app"
  ];

  initialWindowPlacements = concatMap (
    workspace:
    map (app: ''
      [[on-window-detected]]
      if.app-id = '${app}'
      run = ['move-node-to-workspace ${workspace.name}']
    '') workspace.apps
  ) workspaces;

  rawConfig = ''
    after-login-command = [
      'exec-and-forget sketchybar'
    ]
    after-startup-command = [
      'exec-and-forget borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0'
    ]

    # Notify Sketchybar about workspace change
    exec-on-workspace-change = [
      '/bin/bash', '-c', 'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE'
    ]

    start-at-login = true

    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true

    on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

    accordion-padding = 10

    default-root-container-layout = 'accordion'
    default-root-container-orientation = 'auto'
    non-empty-workspaces-root-containers-layout-on-startup = 'smart'

    gaps.inner.horizontal = 0
    gaps.inner.vertical =   0
    gaps.outer.left =       0
    gaps.outer.bottom =     0
    gaps.outer.top =        0
    gaps.outer.right =      0

    [mode.main.binding]
    ${modifierKey}-enter = 'exec-and-forget kitty'

    cmd-h = [] # Disable "hide application"
    cmd-alt-h = [] # Disable "hide others"

    ${modifierKey}-period = 'layout tiles horizontal vertical'
    ${modifierKey}-comma = 'layout accordion horizontal vertical'
    ${modifierKey}-f = 'fullscreen'
    ${modifierKey}-shift-c = 'reload-config'

    ${concatStringsSep "\n" (map (ws: "${modifierKey}-${ws.key} = 'focus ${ws.direction}'") directions)}

    ${concatStringsSep "\n" (
      map (ws: "${modifierKey}-cmd-${ws.key} = 'move-through ${ws.direction}'") directions
    )}

    ${modifierKey}-shift-minus = 'resize smart -50'
    ${modifierKey}-shift-equal = 'resize smart +50'

    ${concatStringsSep "\n" (map (ws: "${modifierKey}-${ws.key} = 'workspace ${ws.name}'") workspaces)}

    ${concatStringsSep "\n" (
      map (ws: "${modifierKey}-cmd-${ws.key} = 'move-node-to-workspace ${ws.name}'") workspaces
    )}

    ${concatStringsSep "\n" initialWindowPlacements}

    ${concatStringsSep "\n" (
      map (ws: ''
        [[on-window-detected]]
        if.app-id = '${ws}'
        run = ['layout floating']
      '') floating_windows
    )}
  '';

  configFile = pkgs.writeText "aerospace.toml" rawConfig;

  cfg = config.JenSeReal.desktop.window-managers.aerospace;
in
{
  options.JenSeReal.desktop.window-managers.aerospace = {
    enable = mkEnableOption "Enable aerospace";
  };

  config = mkIf cfg.enable {
    # services.aerospace.enable = true;

    JenSeReal.programs.cli.homebrew = {
      enable = true;
      additional_casks = [ "nikitabobko/tap/aerospace" ];
      additional_taps = [ "nikitabobko/tap" ];
    };

    JenSeReal.desktop.addons.jankyborders = enabled;

    launchd.user.agents.aerospace = {
      command = "/Applications/AeroSpace.app/Contents/MacOS/AeroSpace --config-path ${configFile}";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
