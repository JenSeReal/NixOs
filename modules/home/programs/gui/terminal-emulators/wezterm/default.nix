{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.JenSeReal.programs.gui.terminal-emulators.wezterm;
in
{
  options.JenSeReal.programs.gui.terminal-emulators.wezterm = {
    enable = mkEnableOption "Whether or not to add wezterm.";
  };

  # TODO: colors are not there yet
  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require 'wezterm'

        return {
          -- The color scheme
          colors = {
            foreground = "#ffffff",
            background = "#2b213a",
            cursor_bg = "#ffffff",
            cursor_border = "#ffffff",
            cursor_fg = "#2b213a",
            selection_bg = "#5a5a5a",
            selection_fg = "none",
            ansi = {"#2b213a", "#ff5370", "#29d398", "#ffd866", "#02EDF9", "#FF7DDA", "#02EDF9", "#ffffff"},
            brights = {"#755390", "#ff637f", "#3FDAA4", "#ffeb85", "#3FC4DE", "#F075B7", "#6BE4E6", "#f8f8f2"},
            scrollbar_thumb = "#5a5a5a",
            split = "#5a5a5a",
            tab_bar = {
              background = "#2b213a",
              active_tab = {
                bg_color = "#ff5370",
                fg_color = "#ffffff",
              },
              inactive_tab = {
                bg_color = "#2b213a",
                fg_color = "#755390",
              },
              inactive_tab_hover = {
                bg_color = "#2b213a",
                fg_color = "#755390",
              },
              new_tab = {
                bg_color = "#2b213a",
                fg_color = "#ffffff",
              },
              new_tab_hover = {
                bg_color = "#2b213a",
                fg_color = "#ffffff",
                italic = true,
              },
            },
          },

          -- URL highlight color
          hyperlink_rules = {
            {
              regex = "\\b\\w+://[\\w.-]+\\S*\\b",
              format = "$0",
            },
          },

          -- Window and Tab settings
          enable_tab_bar = true,
          hide_tab_bar_if_only_one_tab = true,
          window_padding = {
            left = 10,
            right = 10,
            top = 10,
            bottom = 10,
          },
          window_background_opacity = 1.0,
          text_background_opacity = 1.0,
          inactive_pane_hsb = {
            saturation = 0.9,
            brightness = 0.7,
          },
          default_cursor_style = 'SteadyBar',
        }
      '';
    };
  };
}
