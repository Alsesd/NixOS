{pkgs, ...}: {
  # Add eww to your packages
  home.packages = with pkgs; [
    eww
  ];

  # Create eww configuration files
  xdg.configFile."eww/eww.yuck".text = ''
    ;; Variables
    (defvar tray-visible false)

    ;; Window definition for tray popup
    (defwindow tray-popup
      :monitor "1"
      :geometry (geometry
        :x "12px"
        :y "12px"
        :width "250px"
        :height "60px"
        :anchor "top right")
      :stacking "overlay"
      :exclusive false
      :focusable false
      (tray-widget))

    ;; Tray widget content
    (defwidget tray-widget []
      (eventbox
        :onhoverlost "eww close tray-popup"
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

  # Create toggle script
  home.file.".local/bin/toggle-tray".text = ''
    #!/usr/bin/env bash
    if grep -q "\*tray-popup" | eww active-windows; then
      eww open tray-popup
    else
      eww close tray-popup
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
