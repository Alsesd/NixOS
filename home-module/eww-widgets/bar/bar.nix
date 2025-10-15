{pkgs, ...}: {
  xdg.configFile."eww/bar.yuck".text = ''
    defwindow bar
    :window-type "dock"
    :geometry (geometry
      :x "0px"
      :y "0px"
      :width "90%"
      :height "30px"
      :anchor "top center"
      :stacking "overlay"
        :exclusive true
        :focusable false
        label:"Eww Bar")
  '';
}
