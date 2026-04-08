{pkgs}: {
  python = pkgs.mkShell {
    buildInputs = [
      (pkgs.python312.withPackages (ps:
        with ps; [
          jupyterlab
          jupyterlab-lsp
          jupyter-lsp
          python-lsp-server
          ipykernel
          notebook
        ]))
      pkgs.poetry
      pkgs.nodejs
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
      pkgs.libGL
      pkgs.libGLU
      pkgs.cudaPackages.cudatoolkit
      pkgs.cudaPackages.cudnn
    ];
    shellHook = ''
      export CUDA_HOME=${pkgs.cudaPackages.cudatoolkit}
      export LD_LIBRARY_PATH=$(dirname $(realpath /run/opengl-driver/lib/libGL.so.1 2>/dev/null) 2>/dev/null):${pkgs.cudaPackages.cudatoolkit}/lib:${pkgs.cudaPackages.cudnn}/lib:${pkgs.libGL}/lib:${pkgs.libGLU}/lib:${pkgs.zlib}/lib:${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH
      export XLA_FLAGS="--xla_gpu_cuda_data_dir=${pkgs.cudaPackages.cudatoolkit}"
      poetry env use $(which python3.12) --quiet 2>/dev/null
      source $(poetry env info --path)/bin/activate
      python -m ipykernel install --user --name=ml-rnn --display-name="ML RNN" --force 2>/dev/null
      echo "Shell ready. CUDA: $(nvcc --version 2>/dev/null | grep release || echo 'not found')"
    '';
  };
}
