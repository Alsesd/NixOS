{
  pkgs,
  vars,
  ...
}: {
  home-manager.users.${vars.username} = {
    programs.fastfetch = {
      enable = true;
      package = pkgs.fastfetch;

      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

        logo = {
          source = "nixos";
          padding = {
            top = 2;
            left = 3;
          };
        };

        modules = [
          "break"
          {
            type = "custom";
            format = "┌──────────────────────Hardware──────────────────────┐";
          }
          {
            type = "host";
            key = " PC";
            keyColor = "green";
          }
          {
            type = "cpu";
            key = "│ ├";
            showPeCoreCount = true;
            keyColor = "green";
          }
          {
            type = "gpu";
            key = "│ ├󰍛";
            keyColor = "green";
          }
          {
            type = "memory";
            key = "│ ├󰍛";
            keyColor = "green";
          }
          {
            type = "swap";
            key = "│ ├󰓡";
            keyColor = "green";
          }
          {
            type = "disk";
            key = "│ ├";
            keyColor = "green";
          }
          {
            type = "display";
            key = "│ ├󰍹";
            keyColor = "green";
          }
          {
            type = "sound";
            key = "└ └󰓃";
            keyColor = "green";
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
          }
          "break"
          {
            type = "custom";
            format = "┌──────────────────────Software──────────────────────┐";
          }
          {
            type = "os";
            key = " OS";
            keyColor = "yellow";
          }
          {
            type = "command";
            text = "echo \${USER}@\${HOSTNAME}";
            key = "│ ├";
            keyColor = "yellow";
          }
          {
            type = "kernel";
            key = "│ ├";
            keyColor = "yellow";
          }
          {
            type = "gpu";
            key = "│ ├󰍛";
            format = "{3}";
            keyColor = "yellow";
          }
          {
            type = "packages";
            key = "└ └󰏖";
            keyColor = "yellow";
          }
          "break"
          {
            type = "de";
            key = " DE";
            keyColor = "blue";
          }
          {
            type = "wm";
            key = " WM";
            keyColor = "blue";
          }
          {
            type = "lm";
            key = "│ ├";
            keyColor = "blue";
          }
          {
            type = "terminal";
            key = "│ ├";
            keyColor = "blue";
          }
          {
            type = "shell";
            key = "└ └";
            keyColor = "blue";
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
          }
          "break"
          {
            type = "custom";
            format = "┌───────────────────────Themes───────────────────────┐";
          }

          {
            type = "theme";
            key = "󰉼 Theme";
            keyColor = "cyan";
          }
          {
            type = "wmtheme";
            key = "│ ├󰉼";
            keyColor = "cyan";
          }
          {
            type = "icons";
            key = "│ ├";
            keyColor = "cyan";
          }
          {
            type = "cursor";
            key = "│ ├󰆿";
            keyColor = "cyan";
          }
          {
            type = "font";
            key = "│ ├";
            keyColor = "cyan";
          }
          # {
          # type = "terminalfont";
          # key = "└ └";
          # keyColor = "cyan";
          # }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
          }
        ];
      };
    };
  };
}
