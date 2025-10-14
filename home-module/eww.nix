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
      :monitor 0
      :geometry (geometry
        :x "0px"
        :y "48px"
        :width "300px"
        :height "auto"
        :anchor "top right")
      :stacking "overlay"
      :exclusive false
      :focusable true
      (tray-widget))

    ;; Tray widget content
    (defwidget tray-widget []
      (box
        :class "tray-container"
        :orientation "v"
        :space-evenly false
        :spacing 10
        (box
          :class "tray-header"
          :orientation "h"
          (label
            :text "System Tray"
            :class "tray-title"
            :halign "start"
            :hexpand true)
          (button
            :class "close-button"
            :onclick "eww close tray-popup"
            ""))
        (box
          :class "tray-items"
          :orientation "v"
          :spacing 5
          (systray
            :icon-size 24
            :spacing 10
            :orientation "v"
            :prepend-new true))))
  '';

  xdg.configFile."eww/eww.scss".text = ''
    * {
      all: unset;
      font-family: "CaskaydiaCove Nerd Font";
    }

    .tray-container {
      background-color: rgba(50, 56, 68, 0.95);
      border-radius: 10px;
      padding: 15px;
      margin: 6px;
      border: 2px solid rgba(129, 161, 193, 0.3);
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.5);
    }

    .tray-header {
      padding-bottom: 10px;
      border-bottom: 1px solid rgba(220, 223, 225, 0.2);
      margin-bottom: 10px;
    }

    .tray-title {
      color: #dcdfe1;
      font-size: 16px;
      font-weight: bold;
    }

    .close-button {
      color: #FF4040;
      font-size: 18px;
      padding: 0 8px;
      background-color: transparent;
      border-radius: 5px;
    }

    .close-button:hover {
      background-color: rgba(255, 64, 64, 0.2);
    }

    .tray-items {
      min-height: 50px;
    }

    systray {
      background-color: transparent;
    }

    systray > button {
      padding: 8px;
      margin: 2px 0;
      border-radius: 5px;
      background-color: transparent;
    }

    systray > button:hover {
      background-color: rgba(70, 75, 90, 0.9);
    }
  '';

  # Create toggle script
  home.file.".local/bin/toggle-tray".text = ''
    #!/usr/bin/env bash
    if eww windows | grep -q "\*tray-popup"; then
      eww close tray-popup
    else
      eww open tray-popup
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
