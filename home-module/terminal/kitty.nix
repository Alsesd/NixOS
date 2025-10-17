# ============================================================================
# Kitty Terminal Configuration
# ============================================================================
# Stylix автоматически настроит цветовую схему
# ============================================================================
{pkgs, ...}: {
  programs.kitty = {
    enable = true;

    # === Font (Stylix управляет этим) ===
    # font.name определяется через Stylix
    # Но можно переопределить:
    # font = {
    #   name = "JetBrainsMono Nerd Font";
    #   size = 13;
    # };

    # === Shell Integration ===
    shellIntegration = {
      enableBashIntegration = true;
    };

    # === Settings ===
    settings = {
      # === Window ===
      window_padding_width = 8;
      window_margin_width = 0;
      window_border_width = 1;

      # Скрыть заголовок окна
      hide_window_decorations = false;

      # === Cursor ===
      cursor_shape = "block";
      cursor_blink_interval = 0;

      # === Scrollback ===
      scrollback_lines = 10000;

      # === Mouse ===
      mouse_hide_wait = 3;
      copy_on_select = true;

      # === Performance ===
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      # === URLs ===
      url_style = "curly";
      detect_urls = true;

      # === Bell ===
      enable_audio_bell = false;
      visual_bell_duration = 0;

      # === Tabs ===
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      # === Advanced ===
      allow_remote_control = true;
      shell_integration = "enabled";

      # === Misc ===
      confirm_os_window_close = 0;

      # Wayland specific
      wayland_titlebar_color = "system";
      linux_display_server = "wayland";
    };

    # === Key Bindings ===
    keybindings = {
      # === Tabs ===
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";

      # === Windows ===
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+n" = "new_os_window";

      # === Font Size ===
      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";

      # === Scrollback ===
      "ctrl+shift+up" = "scroll_line_up";
      "ctrl+shift+down" = "scroll_line_down";
      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+end" = "scroll_end";

      # === Clipboard ===
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };

    # === Extra Config ===
    extraConfig = ''
      # Custom selection colors (если Stylix не устраивает)
      # selection_background #364A82
      # selection_foreground #C0CAF5

      # Background opacity (если нужно)
      # background_opacity 0.95
    '';
  };
}
