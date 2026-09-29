{ inputs, ... }: {
  flake.nixosModules.antigravity = {
    pkgs,
    lib,
    vars ? { username = "alsesd"; },
    ...
  }: {
    imports = [
      inputs.antigravity.nixosModules.default
    ];

    services.antigravity-dashboard = {
      enable = lib.mkDefault true;
      port = lib.mkDefault 9090;
      user = lib.mkDefault vars.username;
      openFirewall = lib.mkDefault true;
    };
  };
}
