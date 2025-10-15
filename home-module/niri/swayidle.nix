{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    swayidle
    swaylock
    sway
  ];
  services = {
    swayidle = {
      enable = true;
      package = pkgs.swayidle;
      timeouts = [
        {
          timeout = 180;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
        }

        {
          timeout = 185;
          command = "${pkgs.swaylock-effects}/bin/swaylock";
        }

        {
          timeout = 190;
          command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
          resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
        }

        {
          timeout = 195;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock-effects}/bin/swaylock";
        }
      ];
    };
  };
}
