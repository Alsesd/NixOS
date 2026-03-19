# NixOS Fixes Module Refactoring Plan

**Created:** March 17, 2026
**Purpose:** Redistribute fixes.nix into appropriate modules

---

## Current State

`system/fixes.nix` contains fixes that should be integrated into their respective modules:

```
fixes.nix
├── F-001: RealtimeKit → services/audio
├── F-002: UPower → hardware
├── F-003: NVIDIA udev → hardware/gpu
├── F-004: Gnome Keyring PAM → desktop/greetd (already there, remove duplicate)
├── F-005: NetworkManager WiFi → network
├── F-006: ACPI → hardware
└── F-007: Debug packages → split to relevant modules
```

---

## Target Structure

```
nixos/system/
├── hardware/
│   ├── default.nix          ← imports gpu.nix, power.nix
│   ├── gpu.nix              ← NVIDIA config + udev rules (rename from gpu-wayland-env.nix)
│   ├── power.nix            ← NEW: UPower + ACPI
│   ├── bluetooth.nix
│   ├── cpu.nix
│   └── hardware-configuration.nix
├── services/
│   ├── default.nix          ← imports audio.nix
│   ├── audio.nix            ← NEW: RealtimeKit + PipeWire
│   ├── steam.nix
│   ├── wallpaper.nix
│   └── ...
├── network/
│   └── network.nix          ← Add WiFi settings
├── desktop/
│   └── greetd.nix           ← Already has PAM config
└── fixes.nix                ← DELETE after migration
```

---

## Migration Steps

### Step 1: Create Hardware Power Module

**File:** `system/hardware/power.nix`

```nix
{pkgs, ...}: {
  # UPower for battery monitoring
  # Fixes: Failed to get percentage from UPower: NameHasNoOwner
  services.upower.enable = true;

  # ACPI daemon for power events
  # Fixes: ACPI warnings about power management
  services.acpid.enable = true;

  # Power management tools
  environment.systemPackages = with pkgs; [
    powertop
  ];
}
```

**Rationale:** Power management is hardware-related. UPower monitors battery, ACPI handles power events.

---

### Step 2: Update Hardware Default

**File:** `system/hardware/default.nix`

```nix
{...}: {
  imports = [
    ./hardware-configuration.nix
    ./gpu.nix              # renamed from gpu-wayland-env.nix
    ./power.nix            # NEW
    ./users.nix
    ./bluetooth.nix
    ./cpu.nix
  ];
}
```

---

### Step 3: Rename GPU Module

**Rename:** `system/hardware/gpu-wayland-env.nix` → `system/hardware/gpu.nix`

**Add udev rules:**

```nix
# Add to existing gpu.nix after hardware.nvidia block:

# NVIDIA udev rules for device permissions
# Fixes: mknod failed for /dev/nvidiactl and GPU devices
services.udev.extraRules = ''
  KERNEL=="nvidia[0-9]*", MODE="0666"
  KERNEL=="nvidiactl", MODE="0666"
  KERNEL=="nvidia-uvm", MODE="0666"
  KERNEL=="nvidia-uvm-tools", MODE="0666"
'';

# Add nvtop to packages
environment.systemPackages = with pkgs; [
  nvtop
];
```

---

### Step 4: Create Services Audio Module

**File:** `system/services/audio.nix`

```nix
{pkgs, ...}: {
  # RealtimeKit for audio/video realtime priority
  # Fixes: RTKit error: org.freedesktop.DBus.Error.ServiceUnknown
  security.rtkit.enable = true;

  # PipeWire configuration
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Audio tools
  environment.systemPackages = with pkgs; [
    helvum        # PipeWire patchbay
    pavucontrol   # Volume control
  ];
}
```

**Rationale:** RealtimeKit is required by PipeWire for realtime scheduling. Belongs with audio services.

---

### Step 5: Update Services Default

**File:** `system/services/default.nix`

```nix
{...}: {
  imports = [
    ./audio.nix        # NEW
    ./wallpaper.nix
    ./ventoy.nix
    ./bluetooth.nix
    ./ollama.nix
    ./steam.nix
  ];
}
```

---

### Step 6: Update Network Module

**File:** `system/network/network.nix`

Add to existing `networking.networkmanager` block:

```nix
networking.networkmanager = {
  enable = true;
  wifi = {
    powersave = false;           # ADD: stability fix
    scanRandMacAddress = false;  # ADD: stability fix
  };
};
```

---

### Step 7: Update Greetd (Remove Duplicate)

**File:** `system/desktop/greetd.nix`

Already has correct PAM configuration. Remove from fixes.nix.

---

### Step 8: Update Configuration.nix

```nix
imports = [
  ./system/hardware/default.nix   # Now includes power.nix
  ./system/network/default.nix
  ./system/desktop/default.nix
  ./system/services/default.nix   # Now includes audio.nix
  ./system/shell/default.nix
  ./system/terminal/kitty.nix
  ./system/performance.nix
  # ./system/fixes.nix            # DELETE
  ./modules/default.nix
  ./test.nix
];

# Move base debug packages here
environment.systemPackages = with pkgs; [
  wget
  git
  ventoy-full
  usbutils
  docker
  fuse
  fuse3
  nix-output-monitor
  pciutils    # ADD: moved from fixes.nix
  lsof        # ADD: moved from fixes.nix
];
```

---

## Checklist

- [ ] Create `system/hardware/power.nix` with UPower + ACPI
- [ ] Create `system/services/audio.nix` with RealtimeKit + PipeWire
- [ ] Rename `gpu-wayland-env.nix` → `gpu.nix`
- [ ] Add udev rules to `system/hardware/gpu.nix`
- [ ] Add `nvtop` to `system/hardware/gpu.nix`
- [ ] Add WiFi settings to `system/network/network.nix`
- [ ] Update `system/hardware/default.nix` imports
- [ ] Update `system/services/default.nix` imports
- [ ] Move `pciutils`, `lsof` to `configuration.nix`
- [ ] Update `configuration.nix` imports (remove fixes.nix)
- [ ] Delete `system/fixes.nix`
- [ ] Test with `nixos-rebuild test`

---

## Expected Outcome

| Before | After |
|--------|-------|
| `fixes.nix` (7 fixes) | Deleted |
| `services/audio.nix` | New - RealtimeKit, PipeWire |
| `hardware/power.nix` | New - UPower, ACPI |
| `hardware/gpu.nix` | Modified - udev rules, nvtop |
| `network.nix` | Modified - WiFi settings |
| `configuration.nix` | Modified - base packages |

**Result:** No `fixes.nix`, all fixes in appropriate modules.

---

*Plan created for NixOS configuration refactoring.*
