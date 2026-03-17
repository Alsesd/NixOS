{vars, ...}: {
  home-manager.users.${vars.username} = {
    programs.kitty = {
      enable = true;

      settings = {
        window_padding_width = 8;
        window_margin_width = 0;
        window_border_width = 1;
        hide_window_decorations = false;

        cursor_shape = "beam";
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
  };
}
