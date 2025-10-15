 {pkgs, ...}: {

  xdg.configFile."eww/tray.yuck".text = ''
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
 }