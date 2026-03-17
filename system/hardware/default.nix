{...}: {
  imports = [
    ./hardware-configuration.nix
    ./gpu-wayland-env.nix
    ./users.nix
    ./bluetooth.nix
    ./cpu.nix
  ];
}
