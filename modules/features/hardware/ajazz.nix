{ inputs, ... }: {
  perSystem = { system, ... }: {
    packages = {
      ajazz-clock-sync = inputs.ajazz-clock-sync.packages.${system}.default;
      ajazz-control-center = inputs.ajazz-control-center.packages.${system}.default;
    };
  };

  flake.nixosModules.ajazz = {
    imports = [
      inputs.ajazz-clock-sync.nixosModules.default
      inputs.ajazz-control-center.nixosModules.default
    ];

    # Enable Ajazz Control Center (installs GUI app and udev rules for device access)
    programs.ajazz-control-center.enable = true;

    # Enable Ajazz clock sync daemon for wireless mouse dock screens
    services.ajazz-clock-sync.enable = true;
  };
}
