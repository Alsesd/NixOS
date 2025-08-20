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

  programs.sddm = {
    enable = true;
    theme = "dracula";
    programs.kitty = {
      enable = true;
      theme = "dracula";
    };
  };
}
