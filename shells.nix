{pkgs}: {
  # 1. PYTHON SHELL (Lightweight for scripting and general development)
  python = pkgs.mkShell {
    buildInputs = with pkgs; [
      zsh-nix-shell
      python3
      poetry # Poetry is a standalone package, not python3Packages.poetry
      dbeaver-bin
      nodejs_22
      alejandra
      statix
      deadnix
      jq
      dbeaver-bin
      (python3.withPackages (ps:
        with ps; [
          # Core
          pip
          virtualenv
          pylint
          black
          python-lsp-server
          jupyter-lsp # ← critical: Jupyter server extension for LSP
          jupyterlab-lsp # ← frontend extension for JupyterLab

          # Jupyter
          jupyterlab
          notebook
          ipython
          ipykernel

          numpy
          pandas
        ]))
    ];
  };
}
