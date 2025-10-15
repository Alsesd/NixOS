{pkgs, ...}: {
  home.packages = with pkgs; [
    mako
    libnotify
  ];
  programs = {
    mako.enable = true;
    libnotify.enable = true;
  };
}
