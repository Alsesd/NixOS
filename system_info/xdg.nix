# ============================================================================
# XDG Configuration
# ============================================================================
# XDG Base Directory и MIME type конфигурация
# ============================================================================
{pkgs, ...}: {
  # === XDG User Directories ===
  environment.sessionVariables = {
    # Файловый менеджер по умолчанию
    DEFAULT_FILE_MANAGER = "thunar";
    FILE_MANAGER = "thunar";
  };

  # === XDG MIME Types ===
  xdg.mime = {
    enable = true;

  };

  # === Wrapper Scripts ===
  environment.systemPackages = [
    # Wrapper для xdg-open с поддержкой директорий
    (pkgs.writeShellScriptBin "xdg-file-manager" ''
      exec ${pkgs.xfce.thunar}/bin/thunar "$@"
    '')
  ];
}
