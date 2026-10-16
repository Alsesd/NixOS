_: {
  flake.nixosModules.yazi = {vars, ...}: {
    home-manager.users.${vars.username} = {
      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
        enableFishIntegration = true;
        settings = {
          manager = {
            show_hidden = true;
            sort_by = "mtime";
          };
        };
      };
    };
  };
}
