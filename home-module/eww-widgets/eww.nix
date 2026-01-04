{pkgs, ...}: {
  # Add eww to your packages
  home.packages = with pkgs; [
    eww
    jq
  ];
  imports = [
    ./tray/scss.nix
    ./tray/tray.nix
    # ./bar/bar.nix
  ];

  # Main eww configuration file
  xdg.configFile."eww/eww.yuck".text = ''
    ;; Include the tray module at the beginning
    (include "./tray.yuck")
    ;;(include "./bar.yuck")


    ;; Variables
    (defvar tray-visible false)
  '';

  # Main SCSS file with global styles and imports
  xdg.configFile."eww/eww.scss".text = ''
    /* Import tray styles */
    @import "./tray.scss";
    /* @import "./bar.scss"; */

    /* Global styles */
    * {
      all: unset;
      font-family: "CaskaydiaCove Nerd Font";
    }
  '';

  systemd.user.services.eww = {
    Unit = {
      Description = "Eww Daemon";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
      StartLimitBurst = 3;
      StartLimitIntervalSec = 30;
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.eww}/bin/eww daemon --no-daemonize";
      ExecReload = "${pkgs.eww}/bin/eww reload";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
  
}
