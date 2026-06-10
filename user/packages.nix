{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    discord
    qbittorrent
    vlc
    slack
    ayugram-desktop
    easyeffects
    protonup-qt
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    gamemode
  ];

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "mtime";
      };
    };
  };
}
