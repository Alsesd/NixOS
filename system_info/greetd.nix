# ============================================================================
# Greetd Login Manager Configuration
# ============================================================================
# Легковесный TUI login manager с отличной поддержкой Wayland
# ============================================================================
{pkgs, ...}: {
  # === Greetd Service ===
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        # Используем tuigreet - красивый TUI интерфейс
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };

      initial_session = {
        command = "niri-session";
        user = "alsesd";
      };
    };
  };

  # === tuigreet Configuration ===
  environment.etc."greetd/tuigreet-config".text = ''
    # tuigreet settings
    --time
    --remember
    --remember-user-session
    --asterisks
    --greeting "Welcome to NixOS"
  '';

  # === Packages ===
  environment.systemPackages = with pkgs; [
    greetd.tuigreet
  ];

  # === Security ===
  # Разрешить greetd доступ к video группе для работы с GPU
  users.groups.greeter = {};
  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
  };

  # Добавить greeter в video группу для доступа к /dev/dri
  users.users.greeter.extraGroups = ["video"];

  # === Systemd Service Override ===
  # Убедиться что greetd запускается после графики
  systemd.services.greetd = {
    serviceConfig = {
      Type = "idle";
    };
    after = ["systemd-user-sessions.service" "plymouth-quit-wait.service"];
    conflicts = ["plymouth-quit.service"];
  };
}
