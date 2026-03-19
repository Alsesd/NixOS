{pkgs, ...}: {
  home.packages = with pkgs; [
    just
  ];

  home.file.".config/nixos/justfile".text = ''
    flake := "."
    system := "x86_64-linux"

    _track:
        @git add -N .

    # --- SYSTEM ---
    # Build for next boot (Kernel/Drivers safety)
    boot: _track
        @echo "🚀 Building system for next boot..."
        sudo nixos-rebuild boot --flake {{flake}} --no-link |& nom

    # --- DEV SHELL ---
    # Update and Pin the Python/ML environment separately
    pin-shell: _track
        @mkdir -p .gcroots
        @echo "📌 Re-pinning Python/ML shell..."
        nix build {{flake}}#devShells.{{system}}.python -o .gcroots/python --no-link |& nom
        @notify-send "Nix Dev" "Shell environment pinned." -i terminal

    # --- MAINTENANCE ---
    # Update SYSTEM flake inputs only
    update: _track
        @echo "🔄 Updating System Flake inputs..."
        nix flake update
        @echo ""
        @echo "⚠️  REMINDER: System updated, but your Python shell is still pinned to the old version."
        @echo "💡 Run 'just pin-shell' if you want to refresh your ML environment too."
        @notify-send "NixOS" "System inputs updated. Shell remains pinned." -u low

    # The Hook: Prune to 5 gens + GC + Sync Boot Menu
    cleanup:
        @echo "📊 Space before:"
        @df -h /nix/store | tail -n 1
        sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +5
        sudo nix-collect-garbage -d
        find . -maxdepth 2 -name "result*" -not -path "./.gcroots/*" -delete
        sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot
        @echo "✅ Space now:"
        @df -h /nix/store | tail -n 1
  '';
}
