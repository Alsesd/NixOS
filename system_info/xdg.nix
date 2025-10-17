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

    defaultApplications = {
      # File manager
      "inode/directory" = ["thunar.desktop"];

      # Web browser
      "text/html" = ["google-chrome.desktop"];
      "x-scheme-handler/http" = ["google-chrome.desktop"];
      "x-scheme-handler/https" = ["google-chrome.desktop"];

      # Images
      "image/png" = ["swayimg.desktop"];
      "image/jpeg" = ["swayimg.desktop"];
      "image/jpg" = ["swayimg.desktop"];
      "image/gif" = ["swayimg.desktop"];

      # Videos
      "video/mp4" = ["vlc.desktop"];
      "video/x-matroska" = ["vlc.desktop"];

      # Text files
      "text/plain" = ["nvim.desktop"];

      # PDF
      "application/pdf" = ["org.pwmt.zathura.desktop"];
    };
  };

  # === Wrapper Scripts ===
  environment.systemPackages = [
    # Wrapper для xdg-open с поддержкой директорий
    (pkgs.writeShellScriptBin "xdg-file-manager" ''
      exec ${pkgs.xfce.thunar}/bin/thunar "$@"
    '')
  ];
}
