{pkgs, ...}: {
  xdg.configFile."eww/bar.yuck".text = ''
    (defwindow bar
    :window-type "normal"
      :monitor "1"
      :geometry (geometry
        :x "0px"
        :y "0px"
        :width "90%"
        :height "30px"
        :anchor "top center")
      :stacking "overlay"
      :exclusive true
      :focusable false)
  '';
}
