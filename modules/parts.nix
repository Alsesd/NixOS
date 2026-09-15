{inputs, ...}: {
  config = {
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    perSystem = {system, ...}: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          # cudaSupport = true; # Uncomment if you also need CUDA support for packages
        };
      };
    };
  };
}
