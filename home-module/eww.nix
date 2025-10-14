{pkgs, ...}: let
  #####################################################################
  #  tiny helper that decodes one motion event from /dev/input/mice
  #####################################################################
  coordsHelper = pkgs.writeScriptBin "pointer-coords" ''
    #include <stdio.h>
    #include <stdlib.h>
    #include <unistd.h>
    #include <linux/input.h>

    int main(){
        FILE *f = fopen("/dev/input/mice","r");
        if(!f) { perror("mice"); return 1; }
        signed char bytes[3];
        int x=0, y=0;
        while(fread(bytes, 3, 1, f) > 0){
            x += bytes[1];
            y += bytes[2];
            printf("%d %d\n", x, y);   // relative, good enough
            break;
        }
        fclose(f);
        return 0;
    }
  '';
in {
  home.packages = with pkgs; [eww xdotool];

  ###################################################################
  #  Eww config files  (ZERO changes vs your previous file)
  ###################################################################
  xdg.configFile."eww/eww.yuck".text = ''
    ;; Window definition for tray popup - monitor 0 (primary)
    (defwindow tray-popup-0
      :monitor 0
      :geometry (geometry
        :x "10px"
        :y "40px"
        :width "250px"
        :height "60px"
        :anchor "top right")
      :stacking "overlay"
      :exclusive false
      :focusable false
      (tray-widget :monitor "0"))

    ;; Window definition for tray popup - monitor 1 (secondary)
    (defwindow tray-popup-1
      :monitor 1
      :geometry (geometry
        :x "10px"
        :y "40px"
        :width "250px"
        :height "60px"
        :anchor "top right")
      :stacking "overlay"
      :exclusive false
      :focusable false
      (tray-widget :monitor "1"))

    ;; Tray widget content
    (defwidget tray-widget [monitor]
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
          :class "tray-systray")))
  '';

  xdg.configFile."eww/eww.scss".text = ''
    * {
      all: unset;
      font-family: "CaskaydiaCove Nerd Font";
    }

    .tray-container {
      background-color: rgba(50, 56, 68, 0.4);
      border-radius: 10px;
      padding: 8px 12px;
      margin: 0;
      border: 1px solid rgba(129, 161, 193, 0.2);
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
    }

    .tray-systray {
      background-color: transparent;
    }

    .tray-systray > button {
      all: unset;
      padding: 4px;
      margin: 0 2px;
      border-radius: 5px;
      background-color: transparent;
    }

    .tray-systray > button:hover {
      background-color: rgba(70, 75, 90, 0.6);
    }

    /* Fix for tray menu styling */
    menu {
      background-color: rgba(50, 56, 68, 0.95);
      border: 1px solid rgba(129, 161, 193, 0.3);
      border-radius: 8px;
      padding: 4px;
    }

    menuitem {
      background-color: transparent;
      color: #dcdfe1;
      padding: 6px 12px;
      border-radius: 4px;
    }

    menuitem:hover {
      background-color: rgba(70, 75, 90, 0.9);
    }
  '';

  ###################################################################
  #  NEW  toggle-tray  (monitor-aware under Niri)
  ###################################################################
  home.file.".local/bin/toggle-tray".text = ''
                #!${pkgs.bash}/bin/bash
                set -euo pipefail

                EWW=${pkgs.eww}/bin/eww
                NIRI=${pkgs.niri}/bin/niri

                # ------------------------------------------------------------------
                # 1.  read pointer coords  (/dev/input/mice)
                # ------------------------------------------------------------------
                read -r dx dy <<< "$(${coordsHelper}/bin/pointer-coords)"

                # ------------------------------------------------------------------
                # 2.  which Niri output contains that point?
                # ------------------------------------------------------------------
                output=$($NIRI msg outputs | jq -r --argjson dx "$dx" --argjson dy "$dy" '
                  .[] | select(.x <= $dx and .x + .width  > $dx and
                               .y <= $dy and .y + .height > $dy) | .name')

                case "$output" in
                  eDP-1)        monitor=0 ;;
                  HDMI-A-1|DP-1) monitor=1 ;;
                  *)            monitor=0 ;;
                esac

                win="tray-popup-$monitor"

                # ------------------------------------------------------------------
                # 3.  toggle logic
                # ------------------------------------------------------------------
                if $EWW list-windows | grep -q "^\\*$win"; then
                    $EWW close "$win"
                    exit 0
                fi

                # close any other tray window
                $EWW close tray-popup-0 2>/dev/null || true
                $EWW close tray-popup-1 2>/dev/null || true

                # open on the correct monitor
                $EWW open "$win"

       # ------------------------------------------------------------------
    # 4.  watchers  (safe geometry + debug)
    # ------------------------------------------------------------------
    (
      # start with a safe fallback
      wx=0; wy=0; ww=1920; wh=1080

      # try to get real geometry
      json=$(niri msg outputs 2>/dev/null || echo "[]")
      rect=$(echo "$json" | jq -r --arg mon "$output" '
              .[] | select(.name == $mon) | "\(.x) \(.y) \(.width) \(.height)"' 2>/dev/null | head -n1)

      # if jq gave us four numbers, use them
      if [[ -n "$rect" && "$(echo "$rect" | wc -w)" -eq 4 ]]; then
          read -r wx wy ww wh <<< "$rect"
      fi

      echo "DEBUG: widget rect  wx=$wx wy=$wy ww=$ww wh=$wh" >&2
      t0=$(date +%s)
      while sleep 0.5; do
          read -r cx cy <<< "$(${coordsHelper}/bin/pointer-coords)"
          echo "DEBUG: cursor  cx=$cx cy=$cy" >&2

          # inside?
          if (( cx >= wx && cx <= wx + ww && cy >= wy && cy <= wy + wh )); then
              t0=$(date +%s)
              continue
          fi

          # 4 s outside → close
          (( $(date +%s) - t0 >= 4 )) && { $EWW close "$win"; break; }
      done
    ) &

        # ------------------------------------------------------------------
        # 5.  close on any mouse button press  (Niri one-shot)
        # ------------------------------------------------------------------
        (
          # use the same socket Niri is running on
          export NIRI_SOCKET=/run/user/$UID/niri-ipc.sock
          # send a dummy action that returns *only* when a button is pressed
          niri msg action --json-input <<<'{"action":"move-cursor-to","x":0,"y":0}' >/dev/null
          $EWW close "$win"
          pkill -P $$   # stop leave-timer
        ) &
  '';

  home.file.".local/bin/toggle-tray".executable = true;

  ###################################################################
  #  systemd service (unchanged)
  ###################################################################
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
