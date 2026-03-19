{pkgs}: let
  # Using the stable CUDA 12.x/13.x entry point if available,
  # otherwise falling back to the standard cudaPackages.
  cuda_pkg = pkgs.cudaPackages.cudatoolkit;
  cudnn_pkg = pkgs.cudaPackages.cudnn;
in {
  python = pkgs.mkShell {
    name = "ds-ml-shell";

    buildInputs = with pkgs; [
      python3
      poetry
      nodejs # Use stable Node for Jupyter compatibility
      cuda_pkg
      cudnn_pkg
      git # Useful for your repo management

      (python3.withPackages (ps:
        with ps; [
          # Standard Data Science
          numpy
          pandas
          scikit-learn
          matplotlib
          seaborn

          # Jupyter & LSP
          jupyterlab
          notebook
          ipykernel
          python-lsp-server

          # ML Frameworks (Nix handles the CUDA plumbing if configured)
          torch-bin # Use the binary version for easier CUDA linking
          tensorflow-bin
        ]))
    ];

    # CRITICAL: These exports tell the GPU drivers where to find the toolkit
    shellHook = ''
      export CUDA_PATH=${cuda_pkg}
      export LD_LIBRARY_PATH=${cuda_pkg}/lib:${cudnn_pkg}/lib:${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH
      export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
      export EXTRA_CCFLAGS="-I/usr/include"

      echo "--- Data Science Shell ---"
      echo "GPU: GTX 1660 Ti detected via drivers"
      echo "CUDA Path: $CUDA_PATH"
      python --version
    '';
  };
}
