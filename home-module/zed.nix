{
  config,
  pkgs,
  ...
}: let
  colors = config.lib.stylix.colors;
  fonts = config.stylix.fonts;
in {
  home.packages = with pkgs; [
    zed-editor
  ];

  xdg.configFile."zed/settings.json".text = builtins.toJSON {
    telemetry = {
      diagnostics = false;
      metrics = false;
    };

    features = {
      copilot = false;
    };

    vim_mode = false;
    ui_font_size = fonts.sizes.applications;
    buffer_font_size = fonts.sizes.applications;

    ui_font_family = fonts.sansSerif.name;
    buffer_font_family = fonts.monospace.name;

    theme = {
      mode = "dark";
      light = "One Light";
      dark = "Gruvbox Dark Hard";
    };

    base_keymap = "VSCode";

    auto_update = false;
    auto_install_extensions = {};

    tab_bar = {
      show = true;
      show_nav_history_buttons = true;
    };

    tabs = {
      file_icons = true;
      git_status = true;
    };

    scrollbar = {
      show = "auto";
      cursors = true;
      git_diff = true;
      search_results = true;
      selected_symbol = true;
      diagnostics = true;
    };

    relative_line_numbers = false;
    seed_search_query_from_cursor = "selection";

    terminal = {
      shell = {
        program = "zsh";
      };
      font_family = fonts.monospace.name;
      font_size = fonts.sizes.terminal;
      toolbar = {
        title = true;
      };
      working_directory = "current_project_directory";
    };

    assistant = {
      enabled = true;
      default_model = {
        provider = "anthropic";
        model = "claude-sonnet-4-20250514";
      };
      version = "2";
      button = true;
      dock = "right";
    };

    node = {
      path = "${pkgs.nodejs_22}/bin/node";
      npm_path = "${pkgs.nodejs_22}/bin/npm";
    };

    lsp = {
      nixd = {
        binary = {
          path = "${pkgs.nixd}/bin/nixd";
        };
      };
      pyright = {
        binary = {
          path = "${pkgs.pyright}/bin/pyright-langserver";
        };
      };
      rust-analyzer = {
        binary = {
          path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        };
      };
    };

    languages = {
      Nix = {
        language_servers = ["nixd"];
        formatter = {
          external = {
            command = "${pkgs.alejandra}/bin/alejandra";
            arguments = [];
          };
        };
      };
      Python = {
        language_servers = ["pyright"];
        formatter = {
          external = {
            command = "${pkgs.black}/bin/black";
            arguments = ["-"];
          };
        };
      };
      Rust = {
        language_servers = ["rust-analyzer"];
      };
    };

    file_types = {
      Dockerfile = ["Dockerfile" "Dockerfile.*"];
      JSON = ["*.json" "*.jsonc"];
    };

    format_on_save = "on";
    formatter = "language_server";

    git = {
      enabled = true;
      autoFetch = true;
      autoFetchInterval = 300;
      git_gutter = "tracked_files";
    };

    project_panel = {
      button = true;
      dock = "left";
      git_status = true;
    };

    outline_panel = {
      button = true;
      dock = "right";
    };

    collaboration_panel = {
      button = false;
    };

    chat_panel = {
      button = false;
    };

    notification_panel = {
      button = true;
      dock = "right";
    };

    preview_tabs = {
      enabled = true;
      enable_preview_from_file_finder = true;
      enable_preview_from_code_navigation = true;
    };

    indent_guides = {
      enabled = true;
      line_width = 1;
      active_line_width = 1;
      coloring = "indent_aware";
    };

    inlay_hints = {
      enabled = true;
      show_type_hints = true;
      show_parameter_hints = true;
      show_other_hints = true;
    };

    soft_wrap = "none";
    show_whitespaces = "selection";
    remove_trailing_whitespace_on_save = true;
    ensure_final_newline_on_save = true;

    confirm_quit = false;
    restore_on_startup = "last_workspace";
    autosave = "on_focus_change";

    inline_completions = {
      disabled_globs = [".env"];
    };
  };

  xdg.configFile."zed/themes/gruvbox-stylix.json".text = builtins.toJSON {
    "$schema" = "https://zed.dev/schema/themes/v0.1.0.json";
    name = "Gruvbox Stylix";
    author = "Stylix";
    themes = [
      {
        name = "Gruvbox Stylix Dark";
        appearance = "dark";
        style = {
          background = "#${colors.base00}";
          foreground = "#${colors.base05}";

          "editor.background" = "#${colors.base00}";
          "editor.foreground" = "#${colors.base05}";
          "editor.gutter.background" = "#${colors.base00}";
          "editor.line_number" = "#${colors.base03}";
          "editor.active_line_number" = "#${colors.base05}";
          "editor.wrap_guide" = "#${colors.base01}";
          "editor.active_wrap_guide" = "#${colors.base02}";

          "terminal.background" = "#${colors.base00}";
          "terminal.foreground" = "#${colors.base05}";
          "terminal.ansi.black" = "#${colors.base00}";
          "terminal.ansi.red" = "#${colors.base08}";
          "terminal.ansi.green" = "#${colors.base0B}";
          "terminal.ansi.yellow" = "#${colors.base0A}";
          "terminal.ansi.blue" = "#${colors.base0D}";
          "terminal.ansi.magenta" = "#${colors.base0E}";
          "terminal.ansi.cyan" = "#${colors.base0C}";
          "terminal.ansi.white" = "#${colors.base05}";
          "terminal.ansi.bright_black" = "#${colors.base03}";
          "terminal.ansi.bright_red" = "#${colors.base08}";
          "terminal.ansi.bright_green" = "#${colors.base0B}";
          "terminal.ansi.bright_yellow" = "#${colors.base0A}";
          "terminal.ansi.bright_blue" = "#${colors.base0D}";
          "terminal.ansi.bright_magenta" = "#${colors.base0E}";
          "terminal.ansi.bright_cyan" = "#${colors.base0C}";
          "terminal.ansi.bright_white" = "#${colors.base07}";

          "panel.background" = "#${colors.base01}";
          "status_bar.background" = "#${colors.base01}";
          "title_bar.background" = "#${colors.base01}";
          "toolbar.background" = "#${colors.base01}";

          "tab_bar.background" = "#${colors.base01}";
          "tab.inactive_background" = "#${colors.base01}";
          "tab.active_background" = "#${colors.base00}";

          "elevated_surface.background" = "#${colors.base02}";

          border = "#${colors.base03}";
          "border.variant" = "#${colors.base02}";
          "border.focused" = "#${colors.base0D}";

          text = "#${colors.base05}";
          "text.muted" = "#${colors.base04}";
          "text.placeholder" = "#${colors.base03}";
          "text.disabled" = "#${colors.base03}";
          "text.accent" = "#${colors.base0D}";

          "link_text.hover" = "#${colors.base0D}";

          "scrollbar.thumb.background" = "#${colors.base03}";
          "scrollbar.thumb.hover_background" = "#${colors.base04}";
          "scrollbar.track.background" = "#${colors.base01}";

          "editor.highlighted_line.background" = "#${colors.base01}";

          "editor.document_highlight.read_background" = "#${colors.base02}";
          "editor.document_highlight.write_background" = "#${colors.base02}";

          "search.match_background" = "#${colors.base0A}40";

          "players" = [
            {
              cursor = "#${colors.base0D}";
              selection = "#${colors.base0D}40";
            }
            {
              cursor = "#${colors.base0B}";
              selection = "#${colors.base0B}40";
            }
            {
              cursor = "#${colors.base0E}";
              selection = "#${colors.base0E}40";
            }
            {
              cursor = "#${colors.base0C}";
              selection = "#${colors.base0C}40";
            }
          ];

          syntax = {
            attribute = {
              color = "#${colors.base0A}";
            };
            boolean = {
              color = "#${colors.base09}";
            };
            comment = {
              color = "#${colors.base03}";
            };
            "comment.doc" = {
              color = "#${colors.base04}";
            };
            constant = {
              color = "#${colors.base09}";
            };
            constructor = {
              color = "#${colors.base0D}";
            };
            embedded = {
              color = "#${colors.base0F}";
            };
            emphasis = {
              color = "#${colors.base09}";
            };
            "emphasis.strong" = {
              color = "#${colors.base08}";
              font_weight = 700;
            };
            function = {
              color = "#${colors.base0D}";
            };
            keyword = {
              color = "#${colors.base0E}";
            };
            label = {
              color = "#${colors.base0A}";
            };
            link_text = {
              color = "#${colors.base0C}";
              font_style = "underline";
            };
            link_uri = {
              color = "#${colors.base0C}";
            };
            number = {
              color = "#${colors.base09}";
            };
            operator = {
              color = "#${colors.base05}";
            };
            property = {
              color = "#${colors.base08}";
            };
            punctuation = {
              color = "#${colors.base05}";
            };
            "punctuation.bracket" = {
              color = "#${colors.base05}";
            };
            "punctuation.delimiter" = {
              color = "#${colors.base05}";
            };
            "punctuation.list_marker" = {
              color = "#${colors.base08}";
            };
            "punctuation.special" = {
              color = "#${colors.base0F}";
            };
            string = {
              color = "#${colors.base0B}";
            };
            "string.escape" = {
              color = "#${colors.base0C}";
            };
            "string.regex" = {
              color = "#${colors.base0C}";
            };
            "string.special" = {
              color = "#${colors.base0C}";
            };
            tag = {
              color = "#${colors.base08}";
            };
            "text.literal" = {
              color = "#${colors.base0B}";
            };
            title = {
              color = "#${colors.base0D}";
              font_weight = 700;
            };
            type = {
              color = "#${colors.base0A}";
            };
            variable = {
              color = "#${colors.base08}";
            };
            "variable.special" = {
              color = "#${colors.base0E}";
            };
            variant = {
              color = "#${colors.base0A}";
            };
          };
        };
      }
    ];
  };
}
