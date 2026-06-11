{
  flake.nixosModules.vars = {...}: {
    _module.args.vars = {
      username = "alsesd";
      # Using a string here is safer to prevent build errors if the file is missing
      wallpaper = "/home/alsesd/Pictures/NixWallBin.png";
    };
  };
}
