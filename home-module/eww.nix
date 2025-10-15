{pkgs, ...}: {
  imports = [
    ./eww-widgets/tray/tray.nix
    ./eww-widgets/tray/toggle-tray-script.nix
    ./eww-widgets/tray/scss.nix
  ];
  # Add eww to your packages
  home.packages = with pkgs; [
    eww
    jq
  ];

  xdg.configFile."eww/eww.yuck".text = ''
    ;; Include the tray module at the beginning
    (include "./tray.yuck")

    ;; Variables
    (defvar tray-visible false)
  '';

  xdg.configFile."eww/eww.scss".text = ''
    /* Import tray styles */
    @import "./tray.scss";

    /* Global styles */
    * {
      all: unset;
      font-family: "CaskaydiaCove Nerd Font";
    }
  '';

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
