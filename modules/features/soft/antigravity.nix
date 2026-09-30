{
  flake.nixosModules.antigravity = {
    vars,
    pkgs,
    ...
  }: {
    home-manager.users.${vars.username} = {
      home.packages = with pkgs; [
        antigravity-cli
      ];
      programs.antigravity-cli = {
        enable = true;
        permissions = {
          allow = [];
          ask = ["docker"];
          deny = [
            "nixos-rebuild switch"
            "nixos-rebuild boot"
            "nixos-rebuild build"
            "nixos-rebuild test"

            # nh (nix-helper) host-mutating commands
            "nh os switch"
            "nh os boot"
            "nh os build"
            "nh os test" # Allowed only if explicitly paired with --dry

            # Imperative package mutation
            "nix-env -i"
            "nix-env -e"
            "nix-env -u"
            "nix-env --install"
            "nix-env --uninstall"
            "nix-env --upgrade"

            # Direct systemctl generation / boot triggers
            "systemctl reboot"
            "systemctl poweroff"
            "reboot"
            "poweroff"
            "shutdown"
          ];
        };
        skills = {nixos = "${~/.gemini/config/skills/nixos}";};
        mcpServers = {};
      };
    };
  };
}
