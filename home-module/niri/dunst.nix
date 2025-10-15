{pkgs, ...}: {
  home.packages = with pkgs; [
    dunst
    libnotify
  ];
  programs.dunst = {
    enable = true;
  };
}
