{config, ...}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36; # Reduced from 50
        spacing = 2; # Reduced spacing
        margin-top = 4;
        margin-left = 8;
        margin-right = 8;

        modules-left = ["custom/info" "cpu" "memory"];
        modules-center = ["hyprland/workspaces"];
        modules-right = ["network" "battery" "bluetooth" "pulseaudio" "clock" "custom/lock" "custom/power"];

        "custom/info" = {
          format = "  "; # Smaller icon
          on-click = "sh -c '\${TERMINAL:-kitty} sh -c \"fastfetch; echo; read -p \\\"Press enter to exit...\\\"\"'";
          tooltip = "System Info";
        };

        "hyprland/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "default" = "";
          };
        };

        "custom/lock" = {
          format = " "; # Simpler icon
          on-click = "hyprlock";
          tooltip = "Lock Screen";
        };

        "custom/power" = {
          format = " "; # Simpler icon
          on-click = "wlogout -b 5 -r 1";
          tooltip = "Power Menu";
        };

        network = {
          format-wifi = " {essid}";
          format-ethernet = "󰈀 Wired";
          tooltip-format = "Up: {bandwidthUpBytes} | Down: {bandwidthDownBytes}";
          format-linked = "󱘖 No IP";
          format-disconnected = "󰖪 Disconnected";
          format-alt = " {signalStrength}%";
          interval = 5; # Less frequent updates
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󱐋 {capacity}%";
          interval = 30; # Less frequent updates
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click-right = "pavucontrol";
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };

        memory = {
          format = " {used:0.1f}G";
          tooltip-format = "RAM: {used:0.2f}G/{total:0.2f}G ({percentage}%)";
          interval = 5;
        };

        cpu = {
          format = " {usage}%";
          tooltip-format = "CPU Usage: {usage}%";
          interval = 2;
        };

        clock = {
          interval = 60; # Update every minute
          timezone = "Europe/Kiev"; # Using Kiev for Ukraine
          format = " {:%H:%M}";
          tooltip-format = "{:%A, %B %d, %Y}";
        };

        bluetooth = {
          on-click = "blueman-manager";
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{num_connections} connected";
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-weight: 500;
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background-color: transparent;
        border: none;
        box-shadow: none;
      }

      /* Main container styling */
      .modules-left,
      .modules-center,
      .modules-right {
        background: rgba(22, 27, 29, 0.9);
        border-radius: 12px;
        margin: 4px;
        padding: 2px 8px;
        border: 1px solid rgba(126, 162, 180, 0.2);
      }

      /* Individual modules */
      #workspaces,
      #custom-info,
      #cpu,
      #memory,
      #network,
      #battery,
      #bluetooth,
      #pulseaudio,
      #clock,
      #custom-lock,
      #custom-power {
        background: transparent;
        color: #7ea2b4;
        padding: 2px 6px;
        margin: 0 2px;
        border-radius: 6px;
        transition: all 0.2s ease;
      }

      /* Hover effects */
      #custom-info:hover,
      #cpu:hover,
      #memory:hover,
      #network:hover,
      #battery:hover,
      #bluetooth:hover,
      #pulseaudio:hover,
      #clock:hover,
      #custom-lock:hover,
      #custom-power:hover {
        background: rgba(126, 162, 180, 0.1);
        color: #398bc6;
      }

      /* Workspaces specific styling */
      #workspaces {
        padding: 0;
        margin: 0;
      }

      #workspaces button {
        background: transparent;
        color: #7ea2b4;
        padding: 4px 8px;
        margin: 0 1px;
        border: none;
        border-radius: 6px;
        transition: all 0.2s ease;
      }

      #workspaces button:hover {
        background: rgba(126, 162, 180, 0.1);
        color: #398bc6;
      }

      #workspaces button.active {
        background: rgba(57, 139, 198, 0.3);
        color: #398bc6;
        font-weight: bold;
      }

      /* Status-specific colors */
      #battery.warning {
        color: #8a8a0f;
      }

      #battery.critical {
        color: #d22d72;
      }

      #pulseaudio.muted {
        color: #d22d72;
      }

      #network.disconnected {
        color: #d22d72;
      }

      #custom-power {
        color: #d22d72;
      }

      #custom-lock {
        color: #568c3b;
      }
    '';
  };
}
