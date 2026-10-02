{
  flake.nixosModules.mosh = {pkgs, ...}: {
    programs.mosh = {
      enable = true;
      package = pkgs.mosh.overrideAttrs (old: {
        NIX_CFLAGS_COMPILE = toString (old.NIX_CFLAGS_COMPILE or "") + " -std=c++20";
      });
    };
  };
}
