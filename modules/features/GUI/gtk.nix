_: {
  flake.nixosModules.gtk = {vars, ...}: {
    home-manager.users.${vars.username} = {
      home.pointerCursor.enable = true;

      gtk = {
        enable = true;
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };
    };
  };
}
