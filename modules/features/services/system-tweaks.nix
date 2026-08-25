{
  flake.nixosModules.systemTweaks = {
    config,
    pkgs,
    vars,
    ...
  }: {
    # ============================================================================
    # 1. EARLYOOM — предотвращает жёсткие зависания при нехватке RAM
    # ============================================================================
    services.earlyoom = {
      enable = true;
      # Убиваем процессы, когда осталось менее 5% RAM или 5% свопа
      freeMemThreshold = 5;
      freeSwapThreshold = 5;
      # Не трогаем root-процессы (системные службы), убиваем только юзерские
      preferRegex = "(chrome|firefox|electron|steam|java|python|node|rustc)";
      avoidRegex = "(systemd|ssh|greetd|niri|pipewire|wireplumber)";
      # Уведомление через libnotify, когда что-то убито
      enableNotifications = true;
    };

    # ============================================================================
    # 2. FSTRIM — еженедельная очистка SSD, продлевает жизнь накопителя
    # ============================================================================
    services.fstrim = {
      enable = true;
      interval = "weekly";
    };

    # ============================================================================
    # 3. DIRENV + NIX-DIRENV — автозагрузка окружения при cd в проект
    # ============================================================================
    home-manager.users.${vars.username} = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
        config = {
          global = {
            warn_timeout = "30s";
            hide_env_diff = true;
          };
        };
      };
    };

    # ============================================================================
    # 4. ДОПОЛНИТЕЛЬНЫЕ УЛУЧШЕНИЯ
    # ============================================================================

    # tmpfs для /tmp — быстрее и чище
    boot.tmp.useTmpfs = true;
    boot.tmp.tmpfsSize = "25%";
  };
}
