{
  pkgs,
  inputs,
  ...
}: {
  nix.nixPath = [
    "nixos-config=/home/alsesd/.config/nixos/configuration.nix"
    "nixpkgs=${inputs.nixpkgs}"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
}
