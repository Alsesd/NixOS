{
  flake.nixosModules.noctalia-greeter = {
    config,
    vars,
    ...
  }: {
    services.displayManager.noctalia-greeter = {
      enable = true;

      # Allow passwordless sync of wallpaper, palette, and displays from Noctalia Shell
      passwordless-sync-users = [vars.username];

      # Stylix cursor integration
      cursorTheme.package = config.stylix.cursor.package;

      settings = {
        cursor = {
          theme = config.stylix.cursor.name;
          size = config.stylix.cursor.size;
        };

        keyboard = {
          layout = "us,ua";
          options = "grp:alt_shift_toggle";
          numlock = true;
        };
      };
    };

    # Required for user avatar discovery
    services.accounts-daemon.enable = true;

    # Greetd default command (launching directly into Niri via the module's resolved package)
    # services.greetd.settings.default_session.command = "${config.services.displayManager.noctalia-greeter.package}/bin/noctalia-greeter --cmd niri-session";

    # Expose Stylix fonts system-wide for the unprivileged greeter user
    fonts.packages = [
      config.stylix.fonts.sansSerif.package
      config.stylix.fonts.monospace.package
    ];

    security.polkit.enable = true;
  };
}
