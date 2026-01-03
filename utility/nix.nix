{
  config,
  pkgs,
  inputs,
  ...
}:{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      timerConfig.OnCalendar = "daily";
    };

    settings = {
    download-buffer-size = 134217728; 
    auto-optimise-store = true;
  };
  };
  
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs" 
      "--update-input"
      "home-manager" 
      "--commit-lock-file" 
      "-L" 
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
    
  };
}

