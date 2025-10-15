{pkgs, ...}: {
  # Separate tray SCSS file
  xdg.configFile."eww/tray.scss".text = ''
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
}
