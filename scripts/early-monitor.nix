{pkgs, ...}: let
  # Скрипт для включения HDMI монитора через drm
  enable-hdmi = pkgs.writeShellScriptBin "enable-hdmi" ''
    #!/usr/bin/env bash

    # Ждём пока появятся DRM устройства
    for i in {1..30}; do
      if [ -d /sys/class/drm ]; then
        echo "DRM devices found"
        break
      fi
      sleep 0.5
    done

    # Включаем все HDMI выходы через sysfs
    for card in /sys/class/drm/card*/card*/status; do
      if [ -f "$card" ]; then
        connector=$(dirname "$card")
        connector_name=$(basename "$connector")

        # Проверяем если это HDMI
        if [[ "$connector_name" == *"HDMI"* ]]; then
          echo "Found HDMI connector: $connector_name"

          # Пытаемся включить
          if [ -f "$connector/enabled" ]; then
            echo on > "$connector/enabled" 2>/dev/null || true
          fi
        fi
      fi
    done

    # Также пробуем через niri, если он уже запущен
    if command -v niri &> /dev/null; then
      ${pkgs.niri}/bin/niri msg output HDMI-A-4 on 2>/dev/null || true
    fi

    echo "HDMI monitor enable attempted"
  '';
in {
  environment.systemPackages = [enable-hdmi];

  # Системный сервис который запускается ДО display-manager
  systemd.services.enable-hdmi-early = {
    description = "Enable HDMI monitor before login screen";
    wantedBy = ["multi-user.target"];
    before = ["display-manager.service"];
    after = ["systemd-udev-settle.service"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${enable-hdmi}/bin/enable-hdmi";
      RemainAfterExit = true;
      # Запускаем с привилегиями root для доступа к /sys
      User = "root";
    };
  };

  # Также добавляем udev правило для автоматического включения
  services.udev.extraRules = ''
    # Автоматически включать HDMI при подключении
    ACTION=="change", SUBSYSTEM=="drm", RUN+="${enable-hdmi}/bin/enable-hdmi"
  '';
}
