{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python3

    poetry # Poetry is a standalone package, not python3Packages.poetry

    git

    dbeaver-bin

    vscode

    nil
    nixd
    alejandra
    statix
    deadnix
    tree
    jq

    nodejs_22
    (python3.withPackages (ps:
      with ps; [
        python-lsp-server
        jupyter-lsp # ← critical: Jupyter server extension for LSP
        jupyterlab-lsp # ← frontend extension for JupyterLab

        # Jupyter
        jupyterlab
        notebook
        ipython
        ipykernel

        python-lsp-server
        pylint
      ]))
  ];
}
