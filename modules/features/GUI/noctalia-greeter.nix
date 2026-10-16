{
  flake.nixosModules.noctalia-greeter = {
    config,
    vars,
    inputs,
    pkgs,
    ...
  }: {
    services.displayManager.noctalia-greeter = {
      enable = true;

      # Allow passwordless sync of wallpaper, palette, and displays from Noctalia Shell
      passwordless-sync-users = [vars.username];

      # Wrapped noctalia-greeter package via wrapper-modules
      package = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };

      # Stylix cursor integration
      settings = {
        cursor = {
          theme = config.stylix.cursor.name;
          size = config.stylix.cursor.size;
          path = "${config.stylix.cursor.package}/share/icons/${config.stylix.cursor.name}";
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

    # Expose Stylix fonts system-wide for the unprivileged greeter user
    fonts.packages = [
      config.stylix.fonts.sansSerif.package
      config.stylix.fonts.monospace.package
    ];

    security = {
      polkit.enable = true;
      pam.services.greetd.enableGnomeKeyring = true;
    };
  };
}
