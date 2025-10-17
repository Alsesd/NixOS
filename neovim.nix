{pkgs}: {
  environment.systemPackages = [
    pkgs.neovim
    pkgs.vimPlugins.LazyVim
  ];
}
