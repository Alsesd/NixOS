{...}: {
  imports = [
    ./gpu-wayland-env.nix
    ./hardware-configuration.nix
    ./network.nix
    ./users.nix
  ];
}
