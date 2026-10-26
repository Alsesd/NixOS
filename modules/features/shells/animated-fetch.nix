{
  flake.nixosModules.animated-fetch = {
    pkgs,
    vars,
    ...
  }: {
    home-manager.users.${vars.username} = {
      home.packages = [
        pkgs.fetch
      ];

      xdg.configFile."fetch/config".text = ''
        os
        host
        kernel
        uptime
        packages
        shell
        display
        wm
        terminal
        cpu
        gpu
        memory
        swap
        disk
        battery
        ip

        label_color=cyan
        separator=─
        box=1
        logo_outer=blue
        logo_inner=cyan

        spin=xy
        speed=0.8
        size=1.0
        depth=1.2
        height=24
        light=top-left
        shading_mode=sextants
        v_alignment=center
        h_alignment=left
      '';

      programs.fish.interactiveShellInit = ''
        if status is-interactive; and test -t 1; and command -q fetch
          fetch -l nixos &
          set -g __fetch_pid $last_pid

          function __stop_fetch_on_input --on fish_preexec
            if set -q __fetch_pid
              kill $__fetch_pid 2>/dev/null
              set -e __fetch_pid
              command clear
            end

            functions -e __stop_fetch_on_input
          end
        end
      '';
    };
  };
}
