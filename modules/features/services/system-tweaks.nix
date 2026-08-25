{
  flake.nixosModules.systemTweaks = {
    config,
    pkgs,
    lib,
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
      interval = "weekly"; # Можно "daily", "weekly", "monthly"
    };

    # ============================================================================
    # 3. DIRENV + NIX-DIRENV — автозагрузка окружения при cd в проект
    # ============================================================================
    # Системная часть — разрешаем direnv в nix-shell
    nix.settings = {
      keep-outputs = true;
      keep-derivations = true;
    };

    # Home Manager часть — включаем интеграцию с shell
    home-manager.users.${vars.username} = {
      programs.direnv = {
        enable = true;
        # Кэшируем окружения, чтобы не пересчитывать каждый раз
        nix-direnv = {
          enable = true;
        };
        # Не спрашиваем каждый раз разрешение (доверяем .envrc)
        config = {
          global = {
            warn_timeout = "30s";
            hide_env_diff = true;
          };
        };
      };

      # Добавляем shell hook для zsh (если не сработает автоматически)
      programs.zsh.initContent = /* bash */ '''
        # direnv hook — загружает .envrc при смене директории
        eval "$("${pkgs.direnv}/bin/direnv" hook zsh)"
      ''';
    };

    # ============================================================================
    # 4. ДОПОЛНИТЕЛЬНЫЕ УЛУЧШЕНИЯ (бонус)
    # ============================================================================

    # tmpfs для /tmp — быстрее и чище
    boot.tmp.useTmpfs = true;
    boot.tmp.tmpfsSize = "25%";

    # Более агрессивный GC (оставляем 7 дней + последние 10 поколений)
    nix.gc.options = lib.mkForce "--delete-older-than 7d --max-freed $((5*1024**3))";
  };
}
