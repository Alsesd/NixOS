{pkgs, ...}: {
  home.packages = with pkgs; [
    kanshi
  ];
  xdg.configFile."kanshi/config".text = ''    ;

      profile base {
    	  output HDMI-A-4 {
        enable
        mode 1920x1080@144
        position 1920 0
        scale 1.0
        primary yes
      }
      output eDP-1 {
        enable
        mode 1920x1080@60
        position 0 0
        scale 1.0
        primary no
      }

  '';
  #home.file.".config/kanshi/config".source = xdg.configFile."kanshi/config";
}
