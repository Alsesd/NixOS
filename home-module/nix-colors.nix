{
  pkgs,
  config,
  nix-colors,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default
  ];

  colorScheme = nix-colors.colorSchemes.dracula;


    programs.kitty = {
      enable = true;
      theme = "dracula";
    };
  };
}
