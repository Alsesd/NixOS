{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ly
  ];

  services.displayManager.ly = {
    enable = true;
    settings = true;
  };

  xdg.configFile."/etc/ly/config.ini".text = ''
        path=/run/current-system/sw/bin
    restart_cmd=/run/current-system/systemd/bin/systemctl reboot
    service_name=ly
    setup_cmd=/nix/store/hb43icgm4f0iifksdbik32my4vdxhbfq-xsession-wrapper
    shutdown_cmd=/run/current-system/systemd/bin/systemctl poweroff
    term_reset_cmd=/nix/store/lm4wm3f4ynilxw8yvgqq0hj2ng8ky9xy-ncurses-6.5/bin/tput reset
    term_restore_cursor_cmd=/nix/store/lm4wm3f4ynilxw8yvgqq0hj2ng8ky9xy-ncurses-6.5/bin/tput cnorm
    tty=1
    waylandsessions=/nix/store/6x2y5y0zndim5wgci9mjb6wqwi9ibh5z-desktops/share/wayland-sessions
    x_cmd=
    xauth_cmd=
    xsessions=/nix/store/6x2y5y0zndim5wgci9mjb6wqwi9ibh5z-desktops/share/xsessions


        ;
      };
    }
  '';
}
