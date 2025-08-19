{
  config,
  pkgs,
  ...
}: {
  home.username = "alsesd";
  home.homeDirectory = "/home/alsesd";
  home.stateVersion = "25.05";
  #home-manager.backupFileExtension = "backup";

  home.packages = with pkgs; [
    pkgs.hello
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')
    papirus-icon-theme # Popular dark icon theme
    adwaita-icon-theme # GNOME's default icons
    gnome-themes-extra # Includes Adwaita cursor
    arc-theme # Arc dark theme
    materia-theme # Material design theme
  ];

  # GTK theme configuration (affects most GUI applications)
  gtk = {
    enable = true;

    # Main theme
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    # Icon theme
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    # Cursor theme
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
      size = 24;
    };

    # Font configuration
    font = {
      name = "Inter"; # Modern font, or use "Sans" for system default
      size = 11;
    };

    # GTK3 specific settings
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-button-images = 1;
      gtk-menu-images = 1;
      gtk-enable-event-sounds = 1;
      gtk-enable-input-feedback-sounds = 1;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "rgb";
    };

    # GTK4 specific settings
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    # GTK2 settings for legacy applications
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = 1
      gtk-theme-name = "Adwaita-dark"
      gtk-icon-theme-name = "Papirus-Dark"
      gtk-cursor-theme-name = "Adwaita"
      gtk-cursor-theme-size = 24
      gtk-font-name = "Inter 11"
    '';
  };

  # Qt theme configuration
  qt = {
    enable = true;
    platformTheme.name = "gtk3"; # Make Qt follow GTK theme
    style.name = "adwaita-dark"; # Qt style
  };

  # Environment variables for consistent theming
  home.sessionVariables = {
    # GTK theme
    GTK_THEME = "Adwaita-dark";

    # Qt theming
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_STYLE_OVERRIDE = "adwaita-dark";

    # Cursor theme
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";

    # Force dark mode for applications that support it
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
  };

  # Application-specific dark theme configurations
  programs = {
    # VS Code dark theme
    vscode = {
      enable = true;
      profiles.default.userSettings = {
        "workbench.colorTheme" = "Default Dark Modern";
        "workbench.iconTheme" = "vs-minimal";
        "editor.theme" = "Default Dark Modern";
      };
    };

    # Kitty terminal dark theme
    # kitty = {
    #  enable = true;
    # themeFile = "Tokyo Night"; # Popular dark theme
    #settings = {
    # background_opacity = "0.9";
    #font_family = "FiraCode Nerd Font Mono";
    #font_size = 12;
    #};
    #};

    # Git with dark theme for delta (diff viewer)
    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          features = "decorations";
          syntax-theme = "Monokai Extended Dark";
          plus-style = "syntax #003800";
          minus-style = "syntax #3f0001";
        };
      };
    };

    # Rofi dark theme
    rofi = {
      enable = true;
      theme = "Arc-Dark";
    };
  };

  # XDG configuration files for applications that don't have Home Manager modules
  xdg.configFile = {
    # Discord dark theme (BetterDiscord theme)
    "BetterDiscord/themes/dark.theme.css".text = ''
      /* Dark theme customizations */
      :root {
        --background-primary: #36393f;
        --background-secondary: #2f3136;
        --background-tertiary: #202225;
      }
    '';

    # Thunar (file manager) dark theme
    "gtk-3.0/bookmarks".text = ''
      # Dark themed bookmarks
    '';
  };

  # Services for theme consistency
  services = {
    # XSettings daemon for theme coordination
    xsettingsd = {
      enable = true;
      settings = {
        "Net/ThemeName" = "Adwaita-dark";
        "Net/IconThemeName" = "Papirus-Dark";
        "Gtk/CursorThemeName" = "Adwaita";
        "Gtk/CursorThemeSize" = 24;
        "Net/SoundThemeName" = "freedesktop";
        "Net/EnableEventSounds" = 1;
        "Net/EnableInputFeedbackSounds" = 1;
      };
    };
  };

  # Fonts for better dark theme experience
  fonts.fontconfig.enable = true;

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alsesd/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
