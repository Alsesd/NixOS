{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./system_info/hardware-configuration.nix
    ./system_info/users.nix
    ./system_info/nvidia.nix
    ./system_info/wayland.nix
    ./system_info/greetd.nix
    ./system_info/xdg.nix
    ./fixes.nix

    ./utility/gc.nix
    ./utility/stylix.nix
    ./utility/autoupgrade.nix
    ./utility/niri-session.nix

    ./scripts/active.nix
  ];

  # === Gaming Support ===
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.gamemode.enable = true;

  programs.niri.enable = true;

  # === System Packages ===
  environment.systemPackages = with pkgs; [
    # Base utilities
    wget
    git
    base16-schemes
    cava
    ventoy-full
    xdg-utils
    networkmanager
    usbutils
    udiskie
    direnv
    nix-direnv
    docker

    # Graphics & Vulkan
    mesa
    pkgs.mesa
    libGL
    libGLU
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers
    libglvnd

    # Gaming dependencies
    gamescope
    mangohud

    # 32-bit graphics support (critical for Proton/Steam games)
    pkgsi686Linux.mesa

    # File manager
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin

    # FUSE support
    fuse
    fuse3

    # Audio libraries (games often need these)
    alsa-lib
    alsa-plugins
    pipewire

    # Additional gaming libraries
    SDL2
    openal

    # Proton/Wine dependencies
    wineWowPackages.stable
    winetricks

    # System libraries that games commonly need
    glib
    glibc
    gtk3
    fontconfig
    freetype

    # X11 libraries (for games that need X11 compatibility)
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libXinerama
  ];

  # === Graphics Support ===
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Essential for 32-bit games
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vulkan-loader
      vulkan-validation-layers
      mesa
      libvdpau
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
      libvdpau
    ];
  };

  # === FUSE Configuration ===
  programs.fuse.userAllowOther = true;

  # === Performance ===
  powerManagement.cpuFreqGovernor = "performance";

  # === Security & Services ===
  security.polkit.enable = true;
  virtualisation.docker.enable = true;

  # === Boot Configuration ===
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = ["fuse"];

  # === Networking ===
  networking.hostName = "nixos";
  networking.firewall = {
    enable = true;
    # Open ports for Steam Remote Play and game servers if needed
    allowedTCPPorts = [27036 27037];
    allowedUDPPorts = [27031 27036];
  };

  # === Direnv ===
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # === Nix Configuration ===
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "archiver-3.5.1"
    "ventoy-1.1.07"
  ];

  nix.settings = {
    download-buffer-size = 134217728; # 128 MB
    experimental-features = ["nix-command" "flakes"];
  };

  # === Environment Variables for Gaming ===
  environment.sessionVariables = {
    # Steam/Proton
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

    # Force Wayland for Steam (optional, can disable if issues)
    # SDL_VIDEODRIVER = "wayland";

    # Gamemode
    LD_PRELOAD = "";

    # Help games find libraries
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc
      pkgs.glib
      pkgs.glibc
      pkgs.zlib
      pkgs.libGL
      pkgs.libGLU
      pkgs.mesa
      pkgs.vulkan-loader
      pkgs.alsa-lib
      pkgs.pipewire
      pkgs.SDL2
      pkgs.openal
    ];
  };

  # === System State Version ===
  system.stateVersion = "25.05";
}
