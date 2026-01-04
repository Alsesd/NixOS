{ pkgs, ... }:

let
  layout-switch = pkgs.writeShellScriptBin "layout-switch" ''
    # Switch to the next layout
    ${pkgs.niri}/bin/niri msg action switch-layout next

    # Brief pause to let Niri update state
    sleep 0.05

    # Detect current layout name
    # We use 'niri msg outputs' and find the active (*) layout
    LAYOUT=$(${pkgs.niri}/bin/niri msg outputs | grep -A 10 "Keyboard layouts" | grep "\*" | awk '{print $2}')

    case "$LAYOUT" in
        "English")
            # Gruvbox Green Gradient
            ${pkgs.niri}/bin/niri msg action set-window-gradient --active from="#b8bb26" to="#8ec07c" angle=135
            ${pkgs.libnotify}/bin/notify-send "Layout: EN" -t 800 -h string:x-canonical-private-synchronous:layout-osd
            ;;
        "Ukrainian")
            # Gruvbox Blue Gradient
            ${pkgs.niri}/bin/niri msg action set-window-gradient --active from="#83a598" to="#458588" angle=135
            ${pkgs.libnotify}/bin/notify-send "Layout: UA" -t 800 -h string:x-canonical-private-synchronous:layout-osd
            ;;
        "Russian")
            # Gruvbox Orange/Red Gradient
            ${pkgs.niri}/bin/niri msg action set-window-gradient --active from="#fe8019" to="#fb4934" angle=135
            ${pkgs.libnotify}/bin/notify-send "Layout: RU" -t 800 -h string:x-canonical-private-synchronous:layout-osd
            ;;
    esac
  '';
in
{
  environment.systemPackages = [ layout-switch ];
}