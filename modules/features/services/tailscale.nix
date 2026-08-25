{
  flake.nixosModules.tailscale = {
    pkgs,
    vars,
    ...
  }: {
    home-manager.users.${vars.username} = {
      home.packages = with pkgs; [
        tailscale
      ];
      services.tailscale.enable = true;
    };
  };
}
