{pkgs, ...}: {

  xdg.configFile."eww/tray.yuck".text = ''
    ;; Tray widget content
    (defwidget tray-widget []
      (eventbox
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
      :focusable false
      (tray-widget))
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
}
