{pkgs, ...}: {
  # Add eww to your packages
  home.packages = with pkgs; [
    eww
    jq
  ];

  # Create eww configuration files
  xdg.configFile."eww/eww.yuck".text = ''
    ;; Variables
    (defvar tray-visible false)

    ;; Window definition for tray popup
    (defwindow tray-popup
    :window-type "popup"
      :monitor "1"
      :geometry (geometry
        :x "12px"
        :y "12px"
        :width "250px"
        :height "60px"
        :anchor "top right")
      :stacking "overlay"
      :exclusive false
      :focusable false  ;; Correctly set to false, crucial for Wayland menus
      (tray-widget))

    ;; Tray widget content
    (defwidget tray-widget []
      (eventbox
        ;; REMOVED: :onhoverlost "eww close tray-popup"
        ;; The menu's failure to close often requires a forced kill/close
        ;; of the parent window. The simplest method is a single click,
        ;; so we keep the :onclick to close the window.
        :onclick "eww close tray-popup"
        (box
          :class "tray-container"
          :orientation "h"
          :space-evenly false
          :spacing 5
          (systray
            :icon-size 24
            :spacing 8
            :orientation "h"
            :prepend-new false
            :class "tray-systray"))))
  '';

  xdg.configFile."eww/eww.scss".text = ''
    * {
      all: unset;
      font-family: "CaskaydiaCove Nerd Font";
    }

    .tray-container {
      background-color: rgba(50, 56, 68, 0.4);
      border-radius: 10px;
      padding: 8px 12px;
      margin: 0;
      border: 1px solid rgba(129, 161, 193, 0.2);
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
    }

    .tray-systray {
      background-color: transparent;
    }

    .tray-systray > button {
      all: unset;
      padding: 4px;
      margin: 0 2px;
      border-radius: 5px;
      background-color: transparent;
    }

    .tray-systray > button:hover {
      background-color: rgba(70, 75, 90, 0.6);
    }

    /* Fix for tray menu styling */
    menu {
      background-color: rgba(50, 56, 68, 0.95);
      border: 1px solid rgba(129, 161, 193, 0.3);
      border-radius: 8px;
      padding: 4px;
    }

    menuitem {
      background-color: transparent;
      color: #dcdfe1;
      padding: 6px 12px;
      border-radius: 4px;
    }

    menuitem:hover {
      background-color: rgba(70, 75, 90, 0.9);
    }
  '';

  home.file.".local/bin/toggle-tray".text = ''
    #!/usr/bin/env bash

    MONITOR_ID=$(niri msg --json focused-output 2>/dev/null | jq -r '.model')

    # Логіка Toggle
    if eww active-windows | grep -q "tray-popup"; then
      eww close tray-popup
    else
      eww open tray-popup --screen "$MONITOR_ID"
    fi
  '';

  home.file.".local/bin/toggle-tray".executable = true;

  # Auto-start Eww daemon
  systemd.user.services.eww = {
    Unit = {
      Description = "Eww Daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.eww}/bin/eww daemon --no-daemonize";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
