{pkgs, ...}: {
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  environment.etc."greetd/tuigreet-config".text = ''
    # tuigreet settings
    --time
    --remember
    --remember-user-session
    --asterisks
    --greeting "Welcome to NixOS"
  '';

  environment.systemPackages = with pkgs; [
    tuigreet
  ];

  users.groups.greeter = {};
  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
  };

  users.users.greeter.extraGroups = ["video"];

  systemd.services.greetd = {
    serviceConfig = {
      Type = "idle";
    };
    after = ["systemd-user-sessions.service" "plymouth-quit-wait.service"];
    conflicts = ["plymouth-quit.service"];
  };
}
