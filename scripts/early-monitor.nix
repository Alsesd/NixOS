{pkgs, ...}: let
  # Конфигурация Niri специально для greeter
  niri-greeter-config = pkgs.writeText "niri-greeter.kdl" ''
    output "HDMI-A-4" {
        mode "1920x1080@144.001"
        position x=1920 y=0
    }
    output "eDP-1" {
        mode "1920x1080@60.030"
        position x=0 y=0
    }
  '';

  # Скрипт для настройки мониторов через kernel mode setting
  setup-monitors = pkgs.writeShellScriptBin "setup-monitors" ''
    #!/usr/bin/env bash

    # Проверяем наличие niri
    if ! command -v niri &> /dev/null; then
      echo "Niri not found, skipping monitor setup"
      exit 0
    fi

    # Экспортируем конфигурацию для greeter
    export NIRI_CONFIG="${niri-greeter-config}"

    # Ждём инициализации DRM
    for i in {1..20}; do
      if [ -d /sys/class/drm ] && [ -n "$(ls /sys/class/drm/card*/card*/status 2>/dev/null)" ]; then
        echo "DRM initialized"
        break
      fi
      sleep 0.5
    done

    # Пытаемся запустить niri в фоне для настройки мониторов
    ${pkgs.niri}/bin/niri msg outputs 2>/dev/null || {
      echo "Starting niri daemon for monitor setup..."
      WAYLAND_DISPLAY=wayland-greeter ${pkgs.niri}/bin/niri --session &
      NIRI_PID=$!
      sleep 2

      # Настраиваем мониторы
      ${pkgs.niri}/bin/niri msg output HDMI-A-4 on 2>/dev/null || true
      ${pkgs.niri}/bin/niri msg output HDMI-A-4 mode 1920x1080@144.001 2>/dev/null || true
      ${pkgs.niri}/bin/niri msg output eDP-1 on 2>/dev/null || true

      # Не убиваем niri - пусть работает для greeter
    }

    echo "Monitor setup completed"
  '';
in {
  environment.systemPackages = [setup-monitors];

  # Сервис для настройки мониторов перед display-manager
  systemd.services.setup-monitors-early = {
    description = "Setup monitors before login screen";
    wantedBy = ["display-manager.service"];
    before = ["display-manager.service"];
    after = ["systemd-udev-settle.service" "systemd-logind.service"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${setup-monitors}/bin/setup-monitors";
      RemainAfterExit = true;
      User = "root";
      Environment = [
        "XDG_RUNTIME_DIR=/run"
        "WAYLAND_DISPLAY=wayland-greeter"
      ];
    };
  };

  # Настройка environment для SDDM чтобы использовать оба монитора
  environment.etc."sddm.conf.d/monitors.conf".text = ''
    [General]
    # Используем правильную переменную для настройки мониторов
    DisplayCommand=${pkgs.writeShellScript "sddm-display-setup" ''
      # Настройка мониторов для SDDM
      ${pkgs.niri}/bin/niri msg output HDMI-A-4 on || true
      ${pkgs.niri}/bin/niri msg output eDP-1 on || true
    ''}
  '';

  # Также настраиваем logind для использования обоих мониторов
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };
}
