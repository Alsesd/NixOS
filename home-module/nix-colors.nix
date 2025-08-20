{nix-colors, ...}: {
  imports = [
    nix-colors.homeManagerModules.default
  ];

  colorScheme = nix-colors.colorSchemes.dracula;

  programs.colorScheme.name = "dracula";
  programs.colorScheme.colors = nix-colors.colorSchemes.dracula.colors;
}
