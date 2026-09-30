{
  flake.nixosModules.noctalia-greeter = {
    inputs,
    pkgs,
    config,
    vars,
    ...
  }: let
    # Pull the package directly from the flake input (or use pkgs if provided via overlay)
    noctaliaGreeterPkg = inputs.noctalia-greeter.packages.${pkgs.system}.default;
  in {
    # Import the NixOS module provided by the flake if not already imported in your flake.nix
    imports = [
      inputs.noctalia-greeter.nixosModules.default
    ];

    services.displayManager.noctalia-greeter = {
      enable = true;
      package = noctaliaGreeterPkg;

      # Notice the hyphenated syntax for the flake module:
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

    # Greetd default command (launching directly into Niri)
    services.greetd.settings.default_session.command = "${noctaliaGreeterPkg}/bin/noctalia-greeter --cmd niri-session";

    # Expose Stylix fonts system-wide for the unprivileged greeter user
    fonts.packages = [
      config.stylix.fonts.sansSerif.package
      config.stylix.fonts.monospace.package
    ];

    security.polkit.enable = true;
  };
}
