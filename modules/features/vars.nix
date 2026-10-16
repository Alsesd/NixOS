_: {
  flake.nixosModules.vars = _: {
    _module.args.vars = {
      username = "alsesd";
      wallpaper = "/home/alsesd/Pictures/NixWallBin.png";

      # System Defaults
      terminal = "kitty";
      editor = "zed";
      browser = "zen";
      fileManager = "thunar";

      # System & Kernel Parameters
      stateVersion = "26.11";
      kernel = "latest"; # e.g. "latest", "6_12", "xanmod_latest"
      videoDriver = "nvidia";
      nvidiaDriver = "latest"; # e.g. "latest", "production", "beta"
    };
  };
}
