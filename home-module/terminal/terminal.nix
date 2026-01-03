{
  config,
  pkgs,
  ...
}: let
  colors = config.lib.stylix.colors;
in {
  # === Kitty ===
  programs.kitty = {
    enable = true;

    settings = {
      window_padding_width = 8;
      window_margin_width = 0;
      window_border_width = 1;
      hide_window_decorations = false;

      cursor_shape = "block";
      cursor_blink_interval = 0;

      scrollback_lines = 10000;

      mouse_hide_wait = 3;
      copy_on_select = true;

      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      url_style = "curly";
      detect_urls = true;

      enable_audio_bell = false;
      visual_bell_duration = 0;

      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      allow_remote_control = true;
      shell_integration = "enabled";
      confirm_os_window_close = 0;

      wayland_titlebar_color = "system";
      linux_display_server = "wayland";
    };

    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";

      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+n" = "new_os_window";

      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";

      "ctrl+shift+up" = "scroll_line_up";
      "ctrl+shift+down" = "scroll_line_down";
      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+end" = "scroll_end";

      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };

  # === Zsh ===
  home.packages = [pkgs.pay-respects];
  
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      list-nixos-generations = "nixos-rebuild list-generations";
      ip-show = "curl ifconfig.me";

      nixos-build = "sudo nixos-rebuild build --upgrade --flake ~/.config/nixos/.#myNixos";
      nixos-test = "sudo nixos-rebuild test --upgrade --flake ~/.config/nixos/.#myNixos";
      nixos-switch = "sudo nixos-rebuild switch --upgrade --flake ~/.config/nixos/.#myNixos";

      test-build = "sudo nixos-rebuild build -I nixos-config=/home/alsesd/test/configuration.nix --flake ./test/#myNixos";
      test-test = "sudo nixos-rebuild test -I nixos-config=/home/alsesd/test/configuration.nix --flake ./test/#myNixos";
      test-switch = "sudo nixos-rebuild switch -I nixos-config=/home/alsesd/test/configuration.nix --flake ./test/#myNixos";
      ngc-all = "sudo nix-collect-garbage -d";

      my-system = "cd /home/alsesd/.config/nixos";
      python-shell = "nix develop /home/alsesd/.config/nixos#python";
      jupyter-shell = "nix develop /home/alsesd/.config/nixos#jupyter";
      docker-pyinstaller = "docker run -v \"$(pwd):/src/\" cdrx/pyinstaller-windows \"pyinstaller --onefile\"";
      
      f = "f";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "command-not-found"
        "docker"
        "docker-compose"
      ];
      theme = "";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
      nreb() {
        sudo nixos-rebuild switch --upgrade --flake ~/.config/nixos/.#myNixos && notify-send "NixOS" "Rebuild complete!"
      }
    '';
  };

  # === Starship ===
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      palette = "base16";

      format = "[](base00)$os$username[@](bg:base00 fg:base05)$hostname[](bg:base01 fg:base00)$directory[](fg:base01 bg:base02)$git_branch$git_status[](fg:base02 bg:base03)$c$rust$golang$nodejs$php$java$kotlin$haskell$python$nix_shell[ ](fg:base03)$line_break$character";

      palettes.base16 = {
        base00 = "#${colors.base00}";
        base01 = "#${colors.base01}";
        base02 = "#${colors.base02}";
        base03 = "#${colors.base03}";
        base04 = "#${colors.base04}";
        base05 = "#${colors.base05}";
        base06 = "#${colors.base06}";
        base07 = "#${colors.base07}";
        base08 = "#${colors.base08}";
        base09 = "#${colors.base09}";
        base0A = "#${colors.base0A}";
        base0B = "#${colors.base0B}";
        base0C = "#${colors.base0C}";
        base0D = "#${colors.base0D}";
        base0E = "#${colors.base0E}";
        base0F = "#${colors.base0F}";
      };

      os = {
        style = "bg:base00 fg:base0D";
        disabled = false;
        symbols = {
          NixOS = " ";
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "";
          Manjaro = "";
          Linux = "󰌽";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:base00 fg:base05";
        style_root = "bg:base00 fg:base08";
        format = "[$user]($style)";
      };

      hostname = {
        ssh_only = false;
        ssh_symbol = " ";
        trim_at = ".";
        format = "[$hostname$ssh_symbol ]($style)";
        style = "bg:base00 fg:base05";
      };

      directory = {
        style = "bg:base01 fg:base05";
        format = "[ $path ]($style)";
        read_only = " 󰌾 ";
        read_only_style = "bg:base01 fg:base08";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          Documents = "󰈙 ";
          Downloads = " ";
          Music = "󰝚 ";
          Pictures = " ";
          Developer = "󰲋 ";
          ".config" = " ";
          nixos = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:base02 fg:base05";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:base02 fg:base05";
        format = "[$all_status$ahead_behind ]($style)";
      };

      nix_shell = {
        symbol = " ";
        style = "bg:base03 fg:base0D";
        format = "[ $symbol ($name) ]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:base03 fg:base0B";
        format = "[ $symbol ($version) ]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:base03 fg:base05";
        format = "[ $symbol ($version) ]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:base03 fg:base09";
        format = "[ $symbol ($version) ]($style)";
      };

      golang = {
        symbol = " ";
        style = "bg:base03 fg:base0D";
        format = "[ $symbol ($version) ]($style)";
      };

      php = {
        symbol = "";
        style = "bg:base03 fg:base0E";
        format = "[ $symbol ($version) ]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:base03 fg:base09";
        format = "[ $symbol ($version) ]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:base03 fg:base0E";
        format = "[ $symbol ($version) ]($style)";
      };

      haskell = {
        symbol = "";
        style = "bg:base03 fg:base0F";
        format = "[ $symbol ($version) ]($style)";
      };

      python = {
        symbol = "";
        style = "bg:base03 fg:base0A";
        format = "[ $symbol ($version) ]($style)";
      };

      line_break.disabled = false;

      character = {
        disabled = false;
        success_symbol = "[➜](bold fg:base0B)";
        error_symbol = "[➜](bold fg:base08)";
        vimcmd_symbol = "[](bold fg:base0A)";
      };

      cmd_duration = {
        min_time = 2000;
        format = "took [$duration](bold fg:base0A) ";
      };
    };
  };

  # === Fastfetch ===
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