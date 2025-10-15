{pkgs, ...}: {
  home.packages = with pkgs; [
    mako
    libnotify
  ];
}
