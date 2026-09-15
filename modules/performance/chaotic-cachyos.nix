# modules/performance/chaotic-cachyos.nix
#
# Toggleable CachyOS performance module via Chaotic-Nyx.
# Follows your dendritic mkEnableOption/mkIf pattern so it can be
# flipped on/off from one option without touching other modules.
#
# Requires `chaotic.nixosModules.default` to be imported in your
# top-level flake's module list (see instructions below) — this
# module only wires up the options, it doesn't add the flake input.

{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.performance.chaoticCachyos;

  # Map a short variant name to the matching kernel + nvidia package pair,
  # so you can never accidentally mismatch kernel ABI vs driver build.
  variants = {
    default  = { kernel = pkgs.linuxPackages_cachyos;            nvidia = pkgs.nvidia_cachyos; };
    lts      = { kernel = pkgs.linuxPackages_cachyos-lts;         nvidia = pkgs.nvidia_cachyos-lts; };
    hardened = { kernel = pkgs.linuxPackages_cachyos-hardened;    nvidia = pkgs.nvidia_cachyos-hardened; };
    server   = { kernel = pkgs.linuxPackages_cachyos-server;      nvidia = pkgs.nvidia_cachyos-server; };
  };

  selected = variants.${cfg.variant};
in
{
  options.myModules.performance.chaoticCachyos = {
    enable = lib.mkEnableOption "Chaotic-Nyx CachyOS kernel + scheduler";

    variant = lib.mkOption {
      type = lib.types.enum (builtins.attrNames variants);
      default = "default";
      description = "Which CachyOS kernel variant to use (default = LTO+BORE, matches upstream).";
    };

    scx.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable sched-ext (services.scx) alongside the CachyOS kernel.";
    };

    scx.scheduler = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null; # null = scx's own default (scx_rustland)
      example = "scx_rusty";
      description = "Specific sched-ext scheduler to use. Leave null for the module default.";
    };

    keepStableFallback = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Add a bootloader specialisation running the normal (non-CachyOS)
        kernel, so a bad CachyOS build never leaves you without a
        bootable system — just pick the other entry at boot.
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      boot.kernelPackages = selected.kernel;
      hardware.nvidia.package = selected.nvidia;

      services.scx.enable = cfg.scx.enable;
    }
    (lib.mkIf (cfg.scx.scheduler != null) {
      services.scx.scheduler = cfg.scx.scheduler;
    })
    (lib.mkIf cfg.keepStableFallback {
      specialisation.stable-kernel.configuration = {
        boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
        hardware.nvidia.package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.stable;
      };
    })
  ]);
}
