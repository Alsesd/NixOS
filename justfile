# NixOS System Management
#
# Main Commands:
#   build           - Build system configuration
#   test            - Test configuration (no default)
#   rebuild         - Build + test + switch + reboot
#   safe            - Build + test only (no switch)
#   full            - Update + build + test + switch + reboot
#   rollback        - Rollback to previous generation
#
# Maintenance:
#   gc              - Garbage collect (14 days)
#   gc-all          - Remove ALL old generations
#   cleanup         - GC + optimize store
#   generations     - List all generations
#
# Flake:
#   update          - Update all flake inputs
#   update-input X  - Update specific input
#   check           - Check flake for errors
#
# Dev Shells:
#   python          - Enter Python shell
#   jupyter         - Enter Jupyter shell
#
# Utils:
#   fmt             - Format Nix files
#   lint            - Run static analysis
#   sysinfo         - Show system info
#   ip              - Show public IP

flake := "~/.config/nixos/.#myNixos"
test_flake := "./test/#myNixos"
test_config := "/home/alsesd/test/configuration.nix"

_red := '\033[38;2;251;73;52m'
_green := '\033[38;2;184;187;38m'
_yellow := '\033[38;2;250;189;47m'
_blue := '\033[38;2;131;165;152m'
_cyan := '\033[38;2;142;192;124m'
_reset := '\033[0m'

default:
    @just --list

build:
    @echo "{{_blue}}🔨 Building NixOS configuration...{{_reset}}"
    sudo nixos-rebuild build --upgrade --flake {{flake}}

test:
    @echo "{{_yellow}}🧪 Testing NixOS configuration...{{_reset}}"
    sudo nixos-rebuild test --upgrade --flake {{flake}}

switch:
    @echo "{{_green}} Switching to new NixOS configuration...{{_reset}}"
    sudo nixos-rebuild switch --upgrade --flake {{flake}}

rebuild: build test
    @echo "{{_green}} Switching to new NixOS configuration...{{_reset}}"
    sudo nixos-rebuild switch --upgrade --flake {{flake}}
    @echo "{{_green}} Switch successful! Rebooting in 5 seconds...{{_reset}}"
    @echo "{{_yellow}}Press Ctrl+C to cancel{{_reset}}"
    @sleep 5
    systemctl reboot

safe: build test
    @echo "{{_green}} Build and test successful!{{_reset}}"
    @echo "{{_yellow}}Run 'just rebuild' to apply and reboot{{_reset}}"

full: update build test
    @echo "{{_green}} Switching to new NixOS configuration...{{_reset}}"
    sudo nixos-rebuild switch --upgrade --flake {{flake}}
    @echo "{{_green}} Switch successful! Rebooting in 5 seconds...{{_reset}}"
    @echo "{{_yellow}}Press Ctrl+C to cancel{{_reset}}"
    @sleep 5
    systemctl reboot

test-build:
    @echo "{{_blue}} Building test configuration...{{_reset}}"
    sudo nixos-rebuild build -I nixos-config={{test_config}} --flake {{test_flake}}

test-test:
    @echo "{{_yellow}} Testing test configuration...{{_reset}}"
    sudo nixos-rebuild test -I nixos-config={{test_config}} --flake {{test_flake}}

test-switch:
    @echo "{{_green}} Switching to test configuration...{{_reset}}"
    sudo nixos-rebuild switch -I nixos-config={{test_config}} --flake {{test_flake}}

generations:
    @echo "{{_blue}} System Generations:{{_reset}}"
    nixos-rebuild list-generations

gc:
    @echo "{{_yellow}}  Running garbage collection...{{_reset}}"
    sudo nix-collect-garbage -d

gc-all:
    @echo "{{_red}}⚠️  WARNING: This will remove ALL old generations!{{_reset}}"
    @echo "{{_yellow}}Press Ctrl+C to cancel, or wait 5 seconds to continue...{{_reset}}"
    @sleep 5
    sudo nix-collect-garbage -d
    sudo nix-store --gc

optimize:
    @echo "{{_cyan}}⚡ Optimizing Nix store...{{_reset}}"
    sudo nix-store --optimize

cleanup: gc optimize
    @echo "{{_green}} Cleanup complete!{{_reset}}"

update:
    @echo "{{_cyan}} Updating flake inputs...{{_reset}}"
    cd ~/.config/nixos && nix flake update

update-input input:
    @echo "{{_cyan}} Updating {{input}}...{{_reset}}"
    cd ~/.config/nixos && nix flake lock --update-input {{input}}

info:
    @echo "{{_cyan}}ℹ️  Flake Information:{{_reset}}"
    cd ~/.config/nixos && nix flake show

check:
    @echo "{{_cyan}} Checking flake...{{_reset}}"
    cd ~/.config/nixos && nix flake check

python:
    @echo "{{_green}} Entering Python shell...{{_reset}}"
    nix develop ~/.config/nixos#python

jupyter:
    @echo "{{_green}} Entering Jupyter shell...{{_reset}}"
    nix develop ~/.config/nixos#jupyter

sysinfo:
    @echo "{{_cyan}} System Information:{{_reset}}"
    @echo ""
    @fastfetch

ip:
    @echo "{{_cyan}} Public IP:{{_reset}}"
    @curl -s ifconfig.me
    @echo ""

config:
    @cd ~/.config/nixos && $SHELL

disk:
    @echo "{{_cyan}} Disk Usage:{{_reset}}"
    @df -h /

store-size:
    @echo "{{_cyan}} Nix Store Size:{{_reset}}"
    @du -sh /nix/store

rollback:
    @echo "{{_yellow}} Rolling back to previous generation...{{_reset}}"
    sudo nixos-rebuild switch --rollback

boot-generation gen:
    @echo "{{_yellow}} Setting generation {{gen}} as default for next boot...{{_reset}}"
    sudo nix-env --switch-generation {{gen}} -p /nix/var/nix/profiles/system
    @echo "{{_green}} Reboot to activate generation {{gen}}{{_reset}}"

fmt:
    @echo "{{_cyan}} Formatting Nix files...{{_reset}}"
    cd ~/.config/nixos && alejandra .

deadcode:
    @echo "{{_cyan}} Checking for dead code...{{_reset}}"
    cd ~/.config/nixos && deadnix

lint:
    @echo "{{_cyan}} Running static analysis...{{_reset}}"
    cd ~/.config/nixos && statix check

check-all: fmt lint deadcode
    @echo "{{_green}} All checks complete!{{_reset}}"
