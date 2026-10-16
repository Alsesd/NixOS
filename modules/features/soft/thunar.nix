{
  flake.nixosModules.thunar = {pkgs, ...}: {
    # ============================================================================
    # FILE MANAGER & SERVICES
    # ============================================================================
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    services.gvfs.enable = true; # Mounting (flash drives, network)
    services.tumbler.enable = true; # Thumbnail generation

    xdg.mime = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["thunar.desktop"];
        "application/pdf" = ["evince.desktop"];
        "text/plain" = ["gedit.desktop"];
        "image/jpeg" = ["eog.desktop"];
        "image/png" = ["eog.desktop"];
        "x-scheme-handler/file" = ["thunar.desktop"];
      };
    };

    environment = {
      systemPackages = [
        (pkgs.writeShellScriptBin "xdg-file-manager" ''
          exec ${pkgs.thunar}/bin/thunar "$@"
        '')
      ];

      sessionVariables = {
        DEFAULT_FILE_MANAGER = "thunar";
        FILE_MANAGER = "thunar";
      };
    };
  };
}
