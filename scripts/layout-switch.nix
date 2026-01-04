{ pkgs, ... }:

let
  layout-switch = pkgs.writeShellScriptBin "layout-switch" ''
    # Switch layout
    ${pkgs.niri}/bin/niri msg action switch-layout next

    sleep 0.05

    # Get layout name
    LAYOUT=$(${pkgs.niri}/bin/niri msg outputs | grep -A 10 "Keyboard layouts" | grep "\*" | awk '{print $2}')

    # Function to send auto-closing notification
    # -t 1000: 1 second timeout
    # -u low: ensures it doesn't stay as a "critical" alert
    # -h string:x-canonical-private-synchronous: replaces previous notification so they don't stack
    send_notification() {
        ${pkgs.libnotify}/bin/notify-send "Layout" "$1" \
            -t 1000 \
            -u low \
            -h string:x-canonical-private-synchronous:layout-osd
    }

    case "$LAYOUT" in
        "English")
            ${pkgs.niri}/bin/niri msg action set-window-gradient --active from="#b8bb26" to="#8ec07c" angle=135
            send_notification "EN"
            ;;
        "Ukrainian")
            ${pkgs.niri}/bin/niri msg action set-window-gradient --active from="#83a598" to="#458588" angle=135
            send_notification "UA"
            ;;
        "Russian")
            ${pkgs.niri}/bin/niri msg action set-window-gradient --active from="#fe8019" to="#fb4934" angle=135
            send_notification "RU"
            ;;
    esac
  '';
in
{
  environment.systemPackages = [ layout-switch ];
}