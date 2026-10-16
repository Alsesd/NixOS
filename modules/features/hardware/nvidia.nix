{
  flake.nixosModules.nvidia = {
    config,
    pkgs,
    vars,
    ...
  }: {
    # ============================================================================
    # HARDWARE & GRAPHICS (NVIDIA)
    # ============================================================================
    services = {
      xserver.videoDrivers = [vars.videoDriver];
      udev.extraRules = ''
        # NVIDIA device nodes - fix permissions
        KERNEL=="nvidia[0-9]*", MODE="0666"
        KERNEL=="nvidiactl", MODE="0666"
        KERNEL=="nvidia-uvm", MODE="0666"
        KERNEL=="nvidia-uvm-tools", MODE="0666"
      '';
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          vulkan-loader
          vulkan-tools
          libvdpau-va-gl
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          vulkan-loader
        ];
      };

      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.${vars.nvidiaDriver};

        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;

        powerManagement = {
          enable = true;
          finegrained = false;
        };
        nvidiaPersistenced = true;

        forceFullCompositionPipeline = false;

        prime = {
          sync.enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };

      nvidia-container-toolkit.enable = true;
    };

    # ============================================================================
    # ENVIRONMENT & VARIABLES (NVIDIA SPECIFIC)
    # ============================================================================
    environment.sessionVariables = {
      # --- NVIDIA Specifics ---
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # Force immediate buffer swaps, reduces stutter when switching windows
      __GL_YIELD = "USLEEP";
      # Reduce Vulkan/GL pipeline stalls
      __GL_MaxFramesAllowed = "1";
      NVD_BACKEND = "direct";
      __GL_SYNC_TO_VBLANK = "0"; # don't wait for vblank on every frame

      # --- VRR (Adaptive Sync / G-Sync) ---
      __GL_VRR_ALLOWED = "1";
      __GL_GSYNC_ALLOWED = "1";

      # --- Proton NVAPI & NVIDIA Reflex ---
      PROTON_ENABLE_NVAPI = "1";
      PROTON_HIDE_NVIDIA_GPU = "0";
      DXVK_STATE_CACHE = "1";
    };
  };
}
