{
  config,
  pkgs,
  ...
}: let
  colors = config.lib.stylix.colors;
  fonts = config.stylix.fonts;
in {
  home.packages = with pkgs; [
    quickshell
    noctalia-shell
  ];

  xdg.configFile."noctalia/settings.json".text = builtins.toJSON {
    appLauncher = {
      customLaunchPrefix = "";
      customLaunchPrefixEnabled = false;
      enableClipPreview = true;
      enableClipboardHistory = false;
      iconMode = "tabler";
      ignoreMouseInput = false;
      pinnedExecs = [];
      position = "center";
      screenshotAnnotationTool = "";
      showCategories = true;
      showIconBackground = true;
      sortByMostUsed = true;
      terminalCommand = "kitty -e";
      useApp2Unit = false;
      viewMode = "list";
    };

    audio = {
      cavaFrameRate = 30;
      externalMixer = "pwvucontrol || pavucontrol";
      mprisBlacklist = [];
      preferredPlayer = "";
      visualizerType = "mirrored";
      volumeOverdrive = false;
      volumeStep = 5;
    };

    bar = {
      backgroundOpacity = config.stylix.opacity.popups;
      capsuleOpacity = 1;
      density = "comfortable";
      exclusive = true;
      floating = false;
      marginHorizontal = 0.25;
      marginVertical = 0.25;
      monitors = [];
      outerCorners = true;
      position = "top";
      showCapsule = true;
      showOutline = false;
      useSeparateOpacity = false;
      widgets = {
        center = [
          {
            characterCount = 2;
            colorizeIcons = false;
            enableScrollWheel = true;
            followFocusedScreen = false;
            groupedBorderOpacity = 1;
            hideUnoccupied = false;
            iconScale = 0.8;
            id = "Workspace";
            labelMode = "index";
            showApplications = false;
            showLabelsOnlyWhenOccupied = true;
            unfocusedIconsOpacity = 1;
          }
        ];
        left = [
          {
            icon = "rocket";
            id = "Launcher";
            usePrimaryColor = false;
          }
          {
            customFont = "";
            formatHorizontal = "HH:mm ddd, MMM dd";
            formatVertical = "HH mm - dd MM";
            id = "Clock";
            tooltipFormat = "HH:mm ddd, MMM dd";
            useCustomFont = false;
            usePrimaryColor = false;
          }
          {
            compactMode = true;
            diskPath = "/";
            id = "SystemMonitor";
            showCpuTemp = true;
            showCpuUsage = true;
            showDiskUsage = false;
            showGpuTemp = false;
            showLoadAverage = false;
            showMemoryAsPercent = false;
            showMemoryUsage = true;
            showNetworkStats = false;
            useMonospaceFont = true;
            usePrimaryColor = false;
          }
          {
            colorizeIcons = false;
            hideMode = "hidden";
            id = "ActiveWindow";
            maxWidth = 145;
            scrollingMode = "hover";
            showIcon = true;
            useFixedWidth = false;
          }
          {
            displayMode = "forceOpen";
            id = "KeyboardLayout";
            showIcon = true;
          }
          {
            hideMode = "idle";
            hideWhenIdle = false;
            id = "MediaMini";
            maxWidth = 145;
            scrollingMode = "hover";
            showAlbumArt = false;
            showArtistFirst = true;
            showProgressRing = true;
            showVisualizer = false;
            useFixedWidth = false;
            visualizerType = "wave";
          }
          {
            colorName = "primary";
            hideWhenIdle = true;
            id = "AudioVisualizer";
            width = 200;
          }
        ];
        right = [
          {
            id = "ScreenRecorder";
          }
          {
            blacklist = [];
            colorizeIcons = false;
            drawerEnabled = true;
            hidePassive = false;
            id = "Tray";
            pinned = [];
          }
          {
            hideWhenZero = false;
            id = "NotificationHistory";
            showUnreadBadge = true;
          }
          {
            deviceNativePath = "";
            displayMode = "onhover";
            hideIfNotDetected = true;
            id = "Battery";
            showNoctaliaPerformance = false;
            showPowerProfiles = false;
            warningThreshold = 30;
          }
          {
            displayMode = "onhover";
            id = "Volume";
          }
          {
            displayMode = "onhover";
            id = "Brightness";
          }
          {
            colorizeDistroLogo = false;
            colorizeSystemIcon = "none";
            customIconPath = "";
            enableColorization = false;
            icon = "noctalia";
            id = "ControlCenter";
            useDistroLogo = false;
          }
        ];
      };
    };

    brightness = {
      brightnessStep = 5;
      enableDdcSupport = false;
      enforceMinimum = true;
    };

    calendar = {
      cards = [
        {
          enabled = true;
          id = "calendar-header-card";
        }
        {
          enabled = true;
          id = "calendar-month-card";
        }
        {
          enabled = true;
          id = "timer-card";
        }
        {
          enabled = true;
          id = "weather-card";
        }
      ];
    };

    colorSchemes = {
      darkMode = true;
      generateTemplatesForPredefined = true;
      manualSunrise = "06:30";
      manualSunset = "18:30";
      matugenSchemeType = "scheme-fruit-salad";
      predefinedScheme = "Gruvbox";
      schedulingMode = "off";
      useWallpaperColors = false;
    };

    controlCenter = {
      cards = [
        {
          enabled = true;
          id = "profile-card";
        }
        {
          enabled = true;
          id = "shortcuts-card";
        }
        {
          enabled = true;
          id = "audio-card";
        }
        {
          enabled = true;
          id = "brightness-card";
        }
        {
          enabled = true;
          id = "weather-card";
        }
        {
          enabled = true;
          id = "media-sysmon-card";
        }
      ];
      diskPath = "/";
      position = "close_to_bar_button";
      shortcuts = {
        left = [
          {
            id = "WiFi";
          }
          {
            id = "Bluetooth";
          }
          {
            id = "ScreenRecorder";
          }
          {
            id = "WallpaperSelector";
          }
        ];
        right = [
          {
            id = "Notifications";
          }
          {
            id = "PowerProfile";
          }
          {
            id = "KeepAwake";
          }
          {
            id = "NightLight";
          }
        ];
      };
    };

    desktopWidgets = {
      enabled = true;
      gridSnap = false;
      monitorWidgets = [
        {
          name = "eDP-1";
          widgets = [
            {
              hideMode = "visible";
              id = "MediaPlayer";
              roundedCorners = true;
              showAlbumArt = true;
              showBackground = true;
              showButtons = true;
              showVisualizer = true;
              visualizerType = "linear";
              x = 100;
              y = 200;
            }
            {
              id = "Weather";
              showBackground = true;
              x = 99;
              y = 294;
            }
          ];
        }
      ];
    };

    dock = {
      animationSpeed = 1;
      backgroundOpacity = 1;
      colorizeIcons = false;
      deadOpacity = 0.6;
      displayMode = "auto_hide";
      enabled = true;
      floatingRatio = 1;
      inactiveIndicators = false;
      monitors = [];
      onlySameOutput = true;
      pinnedApps = ["steam"];
      pinnedStatic = false;
      size = 1;
    };

    general = {
      allowPanelsOnScreenWithoutBar = true;
      animationDisabled = false;
      animationSpeed = 1;
      avatarImage = "/home/alsesd/.face";
      boxRadiusRatio = 1;
      compactLockScreen = false;
      dimmerOpacity = 0.2;
      enableShadows = true;
      forceBlackScreenCorners = false;
      iRadiusRatio = 1;
      language = "";
      lockOnSuspend = true;
      radiusRatio = 1;
      scaleRatio = 1;
      screenRadiusRatio = 1;
      shadowDirection = "bottom_right";
      shadowOffsetX = 2;
      shadowOffsetY = 3;
      showHibernateOnLockScreen = true;
      showScreenCorners = false;
      showSessionButtonsOnLockScreen = true;
    };

    hooks = {
      darkModeChange = "";
      enabled = false;
      performanceModeDisabled = "";
      performanceModeEnabled = "";
      screenLock = "";
      screenUnlock = "";
      wallpaperChange = "";
    };

    location = {
      analogClockInCalendar = false;
      firstDayOfWeek = 1;
      name = "Cherkassy";
      showCalendarEvents = true;
      showCalendarWeather = true;
      showWeekNumberInCalendar = false;
      use12hourFormat = false;
      useFahrenheit = false;
      weatherEnabled = true;
      weatherShowEffects = true;
    };

    network = {
      bluetoothDetailsViewMode = "grid";
      bluetoothHideUnnamedDevices = false;
      bluetoothRssiPollIntervalMs = 10000;
      bluetoothRssiPollingEnabled = false;
      wifiDetailsViewMode = "grid";
      wifiEnabled = true;
    };

    nightLight = {
      autoSchedule = true;
      dayTemp = "6500";
      enabled = false;
      forced = false;
      manualSunrise = "06:30";
      manualSunset = "18:30";
      nightTemp = "4000";
    };

    notifications = {
      backgroundOpacity = 1;
      criticalUrgencyDuration = 15;
      enableKeyboardLayoutToast = true;
      enabled = true;
      location = "top_right";
      lowUrgencyDuration = 3;
      monitors = [];
      normalUrgencyDuration = 8;
      overlayLayer = true;
      respectExpireTimeout = false;
      saveToHistory = {
        critical = true;
        low = true;
        normal = true;
      };
      sounds = {
        criticalSoundFile = "";
        enabled = false;
        excludedApps = "discord,firefox,chrome,chromium,edge";
        lowSoundFile = "";
        normalSoundFile = "";
        separateSounds = false;
        volume = 0.5;
      };
    };

    osd = {
      autoHideMs = 2000;
      backgroundOpacity = 1;
      enabled = true;
      enabledTypes = [0 1 2 4 3];
      location = "top_right";
      monitors = [];
      overlayLayer = true;
    };

    screenRecorder = {
      audioCodec = "opus";
      audioSource = "default_output";
      colorRange = "limited";
      copyToClipboard = false;
      directory = "/home/alsesd/Videos";
      frameRate = 60;
      quality = "very_high";
      showCursor = true;
      videoCodec = "h264";
      videoSource = "portal";
    };

    sessionMenu = {
      countdownDuration = 10000;
      enableCountdown = true;
      largeButtonsLayout = "grid";
      largeButtonsStyle = false;
      position = "center";
      powerOptions = [
        {
          action = "lock";
          command = "";
          countdownEnabled = true;
          enabled = true;
        }
        {
          action = "suspend";
          command = "";
          countdownEnabled = true;
          enabled = true;
        }
        {
          action = "hibernate";
          command = "";
          countdownEnabled = true;
          enabled = true;
        }
        {
          action = "reboot";
          command = "";
          countdownEnabled = true;
          enabled = true;
        }
        {
          action = "logout";
          command = "";
          countdownEnabled = true;
          enabled = true;
        }
        {
          action = "shutdown";
          command = "";
          countdownEnabled = true;
          enabled = true;
        }
      ];
      showHeader = true;
      showNumberLabels = true;
    };

    settingsVersion = 37;

    systemMonitor = {
      cpuCriticalThreshold = 100;
      cpuPollingInterval = 3000;
      cpuWarningThreshold = 80;
      criticalColor = "";
      diskCriticalThreshold = 90;
      diskPollingInterval = 3000;
      diskWarningThreshold = 80;
      enableDgpuMonitoring = false;
      externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
      gpuCriticalThreshold = 90;
      gpuPollingInterval = 3000;
      gpuWarningThreshold = 80;
      loadAvgPollingInterval = 3000;
      memCriticalThreshold = 90;
      memPollingInterval = 3000;
      memWarningThreshold = 80;
      networkPollingInterval = 3000;
      tempCriticalThreshold = 100;
      tempPollingInterval = 3000;
      tempWarningThreshold = 80;
      useCustomColors = false;
      warningColor = "";
    };

    templates = {
      alacritty = false;
      cava = true;
      code = false;
      discord = true;
      emacs = false;
      enableUserTemplates = false;
      foot = false;
      fuzzel = false;
      ghostty = false;
      gtk = false;
      helix = false;
      hyprland = false;
      kcolorscheme = false;
      kitty = true;
      mango = false;
      niri = true;
      pywalfox = false;
      qt = false;
      spicetify = false;
      telegram = false;
      vicinae = false;
      walker = false;
      wezterm = false;
      yazi = false;
      zed = true;
    };

    ui = {
      boxBorderEnabled = false;
      fontDefault = fonts.sansSerif.name;
      fontDefaultScale = 1;
      fontFixed = fonts.monospace.name;
      fontFixedScale = 1;
      panelBackgroundOpacity = config.stylix.opacity.popups;
      panelsAttachedToBar = true;
      settingsPanelMode = "attached";
      tooltipsEnabled = true;
    };

    wallpaper = {
      directory = "/home/alsesd/Pictures";
      enableMultiMonitorDirectories = false;
      enabled = true;
      fillColor = "#${colors.base00}";
      fillMode = "crop";
      hideWallpaperFilenames = false;
      monitorDirectories = [];
      overviewEnabled = false;
      panelPosition = "follow_bar";
      randomEnabled = false;
      randomIntervalSec = 300;
      recursiveSearch = false;
      setWallpaperOnAllMonitors = true;
      solidColor = "#${colors.base00}";
      transitionDuration = 1500;
      transitionEdgeSmoothness = 0.05;
      transitionType = "random";
      useSolidColor = false;
      useWallhaven = false;
      wallhavenApiKey = "";
      wallhavenCategories = "111";
      wallhavenOrder = "desc";
      wallhavenPurity = "100";
      wallhavenQuery = "";
      wallhavenRatios = "";
      wallhavenResolutionHeight = "";
      wallhavenResolutionMode = "atleast";
      wallhavenResolutionWidth = "";
      wallhavenSorting = "relevance";
      wallpaperChangeMode = "random";
    };
  };

  xdg.configFile."noctalia/colors.json".text = builtins.toJSON {
    mError = "#${colors.base08}";
    mHover = "#${colors.base0D}";
    mOnError = "#${colors.base00}";
    mOnHover = "#${colors.base00}";
    mOnPrimary = "#${colors.base00}";
    mOnSecondary = "#${colors.base00}";
    mOnSurface = "#${colors.base07}";
    mOnSurfaceVariant = "#${colors.base06}";
    mOnTertiary = "#${colors.base00}";
    mOutline = "#${colors.base03}";
    mPrimary = "#${colors.base0B}";
    mSecondary = "#${colors.base0A}";
    mShadow = "#${colors.base00}";
    mSurface = "#${colors.base00}";
    mSurfaceVariant = "#${colors.base01}";
    mTertiary = "#${colors.base0D}";
  };

  xdg.configFile."noctalia/plugins.json".text = builtins.toJSON {
    sources = [
      {
        enabled = true;
        name = "Official Noctalia Plugins";
        url = "https://github.com/noctalia-dev/noctalia-plugins";
      }
    ];
    states = {};
    version = 1;
  };
}
