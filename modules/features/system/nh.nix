_: {
  flake.nixosModules.nh = {vars, ...}: {
    programs.nh = {
      enable = true;
      flake = "/home/${vars.username}/.config/nixos";
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
    };
  };
}
