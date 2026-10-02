{
  flake.nixosModules.audio = {
    pkgs,
    ...
  }: {
    # 1. PipeWire infrastructure & low-latency sound server
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;

      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 2048;
        };
      };
    };

    security.rtkit.enable = true;

    # Allow PipeWire-Pulse to load LADSPA plugins from /tmp (essential for NoiseTorch)
    systemd.user.services.pipewire-pulse.environment = {
      LADSPA_PATH = "/tmp:/run/current-system/sw/lib/ladspa";
    };

    # 2. Hardware / Kernel capabilities for virtual microphone noise suppression
    programs.noisetorch.enable = true;

    # 3. Audio tools, DSP processors & volume control
    environment.systemPackages = with pkgs; [
      # Native PipeWire / Wayland mixers
      pwvucontrol
      pavucontrol
      pulsemixer

      # Audio Enhancement Suites (NLSound / ViPER equivalents)
      jamesdsp # Direct Linux counterpart to ViPER4Android & NLSound
      easyeffects

      # Audio DSP & Noise Reduction plugins
      lsp-plugins
      rnnoise-plugin
      deepfilternet
    ];
  };
}
