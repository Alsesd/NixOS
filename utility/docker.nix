# ============================================================================
# UNIFIED DOCKER SERVICES CONFIGURATION
# ============================================================================
# Manages all Docker-related services and configurations for NixOS
# Services included:
#   - OpenClaw: AI coding assistant (systemd service)
#   - PyInstaller: Python executable builder (shell wrapper)
# ============================================================================
{
  config,
  pkgs,
  lib,
  ...
}: {
  # ============================================================================
  # DOCKER ENGINE
  # ============================================================================

  virtualisation.docker = {
    enable = true;

    # Automatically prune unused images/containers weekly
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["--all" "--volumes"];
    };

    # Enable BuildKit for better build performance
    daemon.settings = {
      features = {buildkit = true;};
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
    };
  };

  # ============================================================================
  # OPENCLAW SERVICE (AI Coding Assistant)
  # ============================================================================
  # Official OpenClaw Docker container with systemd integration
  # Repository: https://github.com/phioranex/openclaw
  # Image: ghcr.io/phioranex/openclaw-docker:latest

  systemd.services.openclaw-docker = {
    description = "OpenClaw AI Coding Assistant (Docker)";
    documentation = ["https://github.com/phioranex/openclaw"];

    # Service dependencies
    requires = ["docker.service"];
    after = ["docker.service" "network-online.target"];
    wants = ["network-online.target"];

    # Service configuration
    serviceConfig = {
      Type = "simple";
      User = "alsesd";
      Group = "docker";
      Restart = "on-failure";
      RestartSec = "10s";
      TimeoutStartSec = "300";

      # Security hardening
      PrivateTmp = true;
      NoNewPrivileges = true;

      # Pre-start: Pull latest image and ensure config directory exists
      ExecStartPre = [
        "${pkgs.docker}/bin/docker pull ghcr.io/phioranex/openclaw-docker:latest"
        "${pkgs.coreutils}/bin/mkdir -p /home/alsesd/.openclaw"
      ];

      # Main service: Run OpenClaw gateway
      ExecStart = ''
        ${pkgs.docker}/bin/docker run \
          --rm \
          --name openclaw-gateway \
          --network bridge \
          -p 127.0.0.1:18789:18789 \
          -v /home/alsesd/.openclaw:/home/node/.openclaw:rw \
          -v /home/alsesd/Projects:/home/node/Projects:rw \
          -v /home/alsesd/ml-projects:/home/node/ml-projects:rw \
          -e NODE_ENV=production \
          --memory=4g \
          --cpus=2 \
          ghcr.io/phioranex/openclaw-docker:latest \
          gateway start --foreground
      '';

      # Stop: Clean container removal
      ExecStop = "${pkgs.docker}/bin/docker stop openclaw-gateway";
    };

    # Don't auto-start until onboarding is complete
    # After onboarding, run: sudo systemctl enable openclaw-docker
    wantedBy = lib.mkForce [];
  };

  # ============================================================================
  # PYINSTALLER WRAPPER (Python Executable Builder)
  # ============================================================================
  # Convenient shell wrapper for building Windows executables from Python scripts
  # Image: cdrx/pyinstaller-windows
  # Usage: pyinstaller-windows <script.py>

  environment.systemPackages = with pkgs; [
    docker
    docker-compose

    # PyInstaller Windows executable builder wrapper
    (writeShellScriptBin "pyinstaller-windows" ''
      #!/usr/bin/env bash
      # PyInstaller Windows Builder
      # Builds standalone Windows .exe from Python scripts
      # Usage: pyinstaller-windows <script.py> [additional-pyinstaller-args]

      set -euo pipefail

      # Check if running in a directory with Python files
      if [ ! -f "$1" ] 2>/dev/null; then
        echo "Error: File not found: $1"
        echo "Usage: pyinstaller-windows <script.py> [additional-args]"
        exit 1
      fi

      # Default to --onefile if no additional args provided
      PYINSTALLER_ARGS="''${@:2}"
      if [ -z "$PYINSTALLER_ARGS" ]; then
        PYINSTALLER_ARGS="--onefile"
      fi

      echo "Building Windows executable: $1"
      echo "PyInstaller args: $PYINSTALLER_ARGS"
      echo "Output directory: ./dist/"
      echo ""

      # Run PyInstaller in Docker
      ${docker}/bin/docker run \
        --rm \
        -v "$(pwd):/src/" \
        cdrx/pyinstaller-windows \
        pyinstaller $PYINSTALLER_ARGS "$1"

      echo ""
      echo "✓ Build complete! Executable in ./dist/"
    '')

    # Additional convenience wrapper for quick one-file builds
    (writeShellScriptBin "pyinstaller-quick" ''
      #!/usr/bin/env bash
      # Quick PyInstaller build with sensible defaults
      # Usage: pyinstaller-quick <script.py>

      if [ $# -eq 0 ]; then
        echo "Usage: pyinstaller-quick <script.py>"
        exit 1
      fi

      ${docker}/bin/docker run \
        --rm \
        -v "$(pwd):/src/" \
        cdrx/pyinstaller-windows \
        pyinstaller --onefile --windowed --clean "$@"
    '')
  ];

  # ============================================================================
  # SHELL ALIASES (Convenience)
  # ============================================================================
  # These can be moved to your terminal.nix if preferred

  programs.zsh.shellAliases = {
    # OpenClaw management
    "openclaw-start" = "sudo systemctl start openclaw-docker";
    "openclaw-stop" = "sudo systemctl stop openclaw-docker";
    "openclaw-restart" = "sudo systemctl restart openclaw-docker";
    "openclaw-status" = "sudo systemctl status openclaw-docker";
    "openclaw-logs" = "sudo journalctl -u openclaw-docker -f";
    "openclaw-onboard" = "docker run -it --rm -v ~/.openclaw:/home/node/.openclaw ghcr.io/phioranex/openclaw-docker:latest onboard";

    # Docker maintenance
    "docker-cleanup" = "docker system prune -af --volumes";
    "docker-ps" = "docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'";

    # PyInstaller (legacy alias for backward compatibility)
    "docker-pyinstaller" = "pyinstaller-windows";
  };

  # ============================================================================
  # USER PERMISSIONS
  # ============================================================================
  # Ensure user has docker group access (already configured in your users.nix)

  users.users.alsesd.extraGroups = ["docker"]; # Already configured
}
