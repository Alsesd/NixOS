# ============================================================================
# Niri Wayland Session
# ============================================================================
# Регистрация Niri как Wayland сессии для display manager
# ============================================================================
{pkgs, ...}: {
  # === Register Niri Session ===
  # Niri автоматически предоставляет .desktop файл
  services.displayManager.sessionPackages = [pkgs.niri];

  # === XDG Autostart ===
  # Niri поддерживает автозапуск приложений через XDG
  xdg.autostart.enable = true;

  # === Session Environment ===
  environment.sessionVariables = {
    # Убедимся что переменные установлены для сессии
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };

  # === Systemd User Services ===
  # Убедимся что user services стартуют с graphical-session
  systemd.user.targets.niri-session = {
    description = "Niri compositor session";
    bindsTo = ["graphical-session.target"];
    wants = ["graphical-session-pre.target"];
    after = ["graphical-session-pre.target"];
  };
}
