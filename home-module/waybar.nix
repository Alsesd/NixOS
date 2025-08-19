{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    playerctl
    pavucontrol
    networkmanager
    brightnessctl
  ];

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 4;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/mode"
          "hyprland/scratchpad"
          "custom/media"
        ];

        modules-center = [
          "hyprland/window"
        ];

        modules-right = [
          "mpd"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "keyboard-state"
          "battery"
          "battery#bat2"
          "clock"
          "tray"
        ];

        # Module configurations
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          warp-on-scroll = false;
          format = "{name}: {icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
        };

        "keyboard-state" = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };

        "hyprland/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };

        "hyprland/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = ["" ""];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };

        mpd = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          unknown-tag = "N/A";
          interval = 2;
          consume-icons = {
            on = " ";
          };
          random-icons = {
            off = "<span color=\"#f53c3c\"></span> ";
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        tray = {
          spacing = 10;
        };

        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };

        memory = {
          format = "{}% ";
        };

        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
        };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };

        "battery#bat2" = {
          bat = "BAT2";
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        "custom/media" = {
          format = "{icon} {}";
          return-type = "json";
          max-length = 40;
          format-icons = {
            spotify = "";
            default = "🎜";
          };
          escape = true;
          exec = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null";
        };
      };
    };

    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrains Mono", "Font Awesome 6 Free";
          font-weight: bold;
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background: rgba(43, 48, 59, 0.8);
          border-bottom: 3px solid rgba(100, 114, 125, 0.5);
          color: #ffffff;
          transition-property: background-color;
          transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      #workspaces {
          margin: 0 4px;
      }

      #workspaces button {
          padding: 0 8px;
          background-color: transparent;
          color: #ffffff;
          border-bottom: 3px solid transparent;
          min-width: 40px;
      }

      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.focused {
          background-color: #64727D;
          border-bottom: 3px solid #ffffff;
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }

      #mode {
          background-color: #64727D;
          border-bottom: 3px solid #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #mpd {
          padding: 0 10px;
          color: #ffffff;
      }

      #window,
      #workspaces {
          margin: 0 4px;
      }

      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }

      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }

      #clock {
          background-color: #64727D;
      }

      #battery {
          background-color: #ffffff;
          color: #000000;
      }

      #battery.charging, #battery.plugged {
          color: #ffffff;
          background-color: #26A65B;
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }

      #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      label:focus {
          background-color: #000000;
      }

      #cpu {
          background-color: #2ecc71;
          color: #000000;
      }

      #memory {
          background-color: #9b59b6;
      }

      #disk {
          background-color: #964B00;
      }

      #backlight {
          background-color: #90b1b1;
      }

      #network {
          background-color: #2980b9;
      }

      #network.disconnected {
          background-color: #f53c3c;
      }

      #pulseaudio {
          background-color: #f1c40f;
          color: #000000;
      }

      #pulseaudio.muted {
          background-color: #90b1b1;
          color: #2a5c45;
      }

      #temperature {
          background-color: #f0932b;
      }

      #temperature.critical {
          background-color: #eb4d4b;
      }

      #tray {
          background-color: #2980b9;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }

      #idle_inhibitor {
          background-color: #2d3436;
      }

      #idle_inhibitor.activated {
          background-color: #ecf0f1;
          color: #2d3436;
      }

      #mpd {
          background-color: #66cc99;
          color: #2a5c45;
      }

      #mpd.disconnected {
          background-color: #f53c3c;
      }

      #mpd.stopped {
          background-color: #90b1b1;
      }

      #mpd.paused {
          background-color: #51a37a;
      }

      #language {
          background: #00b093;
          color: #740864;
          padding: 0 5px;
          margin: 0 5px;
          min-width: 16px;
      }

      #keyboard-state {
          background: #97e1ad;
          color: #000000;
          padding: 0 0px;
          margin: 0 5px;
          min-width: 16px;
      }

      #keyboard-state > label {
          padding: 0 5px;
      }

      #keyboard-state > label.locked {
          background: rgba(0, 0, 0, 0.2);
      }
    '';
  };

  # Media player script
  home.file.".config/waybar/mediaplayer.py" = {
    text = ''
      #!/usr/bin/env python3
      import argparse
      import logging
      import sys
      import signal
      import gi
      import json
      gi.require_version('Playerctl', '2.0')
      from gi.repository import Playerctl, GLib

      logger = logging.getLogger(__name__)


      def write_output(text, player):
          logger.info('Writing output')

          output = {'text': text,
                    'class': 'custom-' + player.props.player_name,
                    'alt': player.props.player_name}

          sys.stdout.write(json.dumps(output) + '\n')
          sys.stdout.flush()


      def on_play(player, status, manager):
          logger.info('Received new playback status')
          on_metadata(player, player.props.metadata, manager)


      def on_metadata(player, metadata, manager):
          logger.info('Received new metadata')
          track_info = ''

          if player.props.player_name == 'spotify' and \
                  'mpris:trackid' in metadata.keys() and \
                  ':ad:' in player.props.metadata['mpris:trackid']:
              track_info = 'AD PLAYING'
          elif player.get_artist() != '' and player.get_title() != '':
              track_info = '{artist} - {title}'.format(artist=player.get_artist(),
                                                       title=player.get_title())
          else:
              track_info = player.get_title()

          if player.props.status != 'Playing' and track_info:
              track_info = ' ' + track_info
          write_output(track_info, player)


      def on_player_appeared(manager, player, selected_player=None):
          if player is not None and (selected_player is None or player.name == selected_player):
              init_player(manager, player)
          else:
              logger.debug("New player appeared, but it's not the selected player, skipping")


      def on_player_vanished(manager, player):
          logger.info('Player has vanished')
          sys.stdout.write('\n')
          sys.stdout.flush()


      def init_player(manager, player):
          logger.debug('Initialize player: {player}'.format(player=player.name))
          player.connect('playback-status', on_play, manager)
          player.connect('metadata', on_metadata, manager)
          manager.manage_player(player)
          on_metadata(player, player.props.metadata, manager)


      def signal_handler(sig, frame):
          logger.debug('Received signal to stop, exiting')
          sys.stdout.write('\n')
          sys.stdout.flush()
          # loop.quit()
          sys.exit(0)


      def parse_arguments():
          parser = argparse.ArgumentParser()

          # Increase verbosity with every occurrence of -v
          parser.add_argument('-v', '--verbose', action='count', default=0)

          # Define for which player we're listening
          parser.add_argument('--player')

          return parser.parse_args()


      def main():
          arguments = parse_arguments()

          # Initialize logging
          logging.basicConfig(stream=sys.stderr, level=logging.DEBUG,
                              format='%(name)s %(levelname)s %(message)s')

          # Logging is set by default to WARN and higher.
          # With every occurrence of -v it's lowered by one
          logger.setLevel(max((3 - arguments.verbose) * 10, 0))

          # Log the sent command line arguments
          logger.debug('Arguments received {}'.format(vars(arguments)))

          manager = Playerctl.PlayerManager()
          loop = GLib.MainLoop()

          manager.connect('name-appeared', lambda *args: on_player_appeared(*args, arguments.player))
          manager.connect('player-vanished', on_player_vanished)

          signal.signal(signal.SIGINT, signal_handler)
          signal.signal(signal.SIGTERM, signal_handler)

          for player in manager.props.player_names:
              if arguments.player is not None and arguments.player != player.name:
                  logger.debug('{player} is not the filtered player, skipping it'
                               .format(player=player.name)
                               )
                  continue

              player = Playerctl.Player.new_from_name(player)
              manager.manage_player(player)
              init_player(manager, player)

          loop.run()


      if __name__ == '__main__':
          main()
    '';
    executable = true;
  };
}
