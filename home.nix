{vars, ...}: {
  imports = [
    ./user/default.nix
  ];

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";
  home.stateVersion = "25.05";
}
