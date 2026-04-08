{
  vars,
  config,
  ...
}: {
  imports = [
    ./user/default.nix
  ];
  gtk = {
    enable = true;
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.theme = config.gtk.theme;
  };
  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";
  home.stateVersion = "26.05";
}
