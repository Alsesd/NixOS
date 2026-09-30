{
  flake.nixosModules.noctalia-greeter = {
    pkgs,
    config,
    vars,
    inputs,
    ...
  }: {
    imports = [inputs.noctalia-greeter.nixosModules.default];
    # 1. Enable Noctalia Greeter via the official displayManager service
    services.displayManager.noctalia-greeter = {
      enable = true;

      # Enable passwordless sync from your user account (Stylix / Noctalia Shell wallpaper & colors)
      # Note: if using the external project flake module, the option is `passwordless-sync-users`
      passwordlessSyncUsers = [vars.username];

      # Wire cursor directly from Stylix
      cursorTheme = {
        package = config.stylix.cursor.package;
        name = config.stylix.cursor.name;
      };

      settings = {
        cursor.size = config.stylix.cursor.size;

        # Keyboard layout configuration
        keyboard = {
          layout = "us,ua";
          options = "grp:alt_shift_toggle";
          numlock = true;
        };
      };
    };

    # 2. Accountsservice is required by Noctalia to load user profile pictures/avatars
    services.accounts-daemon.enable = true;

    # 3. Ensure your desktop session is selectable or starts Niri
    services.greetd.settings.default_session.command = "${pkgs.noctalia-greeter}/bin/noctalia-greeter --cmd niri-session";

    # 4. Stylix Font Integration for the greeter
    # Fonts must be installed in systemPackages so the 'greeter' system user can read them
    # fonts.packages = [
    #   config.stylix.fonts.sansSerif.package
    #   config.stylix.fonts.monospace.package
    # ];

    # 5. Security & Polkit
    security.polkit.enable = true;
  };
}
