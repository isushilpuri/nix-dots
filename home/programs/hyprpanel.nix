{ config, pkgs, ... }:
{
  programs.hyprpanel = {
    enable = true;
    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {

      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      # Default: null
      layout = {
        bar.layouts = {
          "0" = {
            left = [ "dashboard" "workspaces" ];
            middle = [ "media" ];
            right = [ "volume" "systray" "notifications" ];
          };
        };
      };

      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;

      bar.clock.format = "%a %b %d  %I:%M %p";

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;

      menus.dashboard.shortcuts.left.shortcut1.icon = "";
      menus.dashboard.shortcuts.left.shortcut1.command = "firfox";
      menus.dashboard.shortcuts.left.shortcut1.tooltip = "Firfox";

      menus.dashboard.shortcuts.left.shortcut2.icon = "";
      menus.dashboard.shortcuts.left.shortcut2.command = "ghostty";
      menus.dashboard.shortcuts.left.shortcut2.tooltip = "Ghostty";

      menus.dashboard.shortcuts.left.shortcut3.icon = "󰹕";
      menus.dashboard.shortcuts.left.shortcut3.command = "obsidian";
      menus.dashboard.shortcuts.left.shortcut3.tooltip = "Obsidian";

      menus.dashboard.shortcuts.left.shortcut4.icon = "";
      menus.dashboard.shortcuts.left.shortcut4.command = "wofi --show drun";
      menus.dashboard.shortcuts.left.shortcut4.tooltip = "Search Apps";

      theme.bar.transparent = true;

      theme.font = {
        name = "IntoneMono Nerd Font";
        size = "12px";
	weight = "400";
      };
    };
  };
}
