{...}: {
  home.file.".local/bin/toggle-tray".text = ''
    #!/usr/bin/env bash

    MONITOR_ID=$(niri msg --json focused-output 2>/dev/null | jq -r '.model')

    # Логіка Toggle
    if eww active-windows | grep -q "tray-popup"; then
      eww close tray-popup
    else
      eww open tray-popup --screen "$MONITOR_ID"
    fi
  '';

  home.file.".local/bin/toggle-tray".executable = true;
}
