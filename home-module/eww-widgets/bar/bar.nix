{pkgs, ...}: {
  xdg.configFile."eww/bar.yuck".text = ''
    (defwindow bar
      :window-type "normal"
      :geometry (geometry
        :x "0px"
        :y "0px"
        :width "90%"
        :height "30px"
        :anchor "top center")
      :stacking "overlay"
      :exclusive true
      :focusable false
      (bar-widget))

    (defwidget bar-widget []
      (centerbox
        :class "bar-container"
        :orientation "h"
        (box
          :class "bar-left"
          :halign "start"
          :space-evenly false
          :spacing 10
          (label :text "  NixOS"))
        (box
          :class "bar-center"
          :halign "center"
          :space-evenly false
          (label :text "Niri WM"))
        (box
          :class "bar-right"
          :halign "end"
          :space-evenly false
          :spacing 10
          (button
            :class "tray-button"
            :onclick "~/.local/bin/toggle-tray"
            "  "))))
  '';

  # Add bar styles
  xdg.configFile."eww/bar.scss".text = ''
    .bar-container {
      background-color: rgba(50, 56, 68, 0.8);
      border-radius: 10px;
      padding: 0 16px;
      margin: 6px;
    }

    .bar-left,
    .bar-center,
    .bar-right {
      padding: 4px 8px;
    }

    .tray-button {
      all: unset;
      padding: 4px 12px;
      border-radius: 6px;
      background-color: rgba(70, 75, 90, 0.4);
      transition: all 0.2s ease;
    }

    .tray-button:hover {
      background-color: rgba(70, 75, 90, 0.8);
    }
  '';
}
