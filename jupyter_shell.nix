{pkgs}: let
  # Shared libraries to fix "ImportError" for Pandas/Numpy
  lib-path = with pkgs;
    lib.makeLibraryPath [
      stdenv.cc.cc
      zlib
      glib
      glibc
      libGL
      libxkbcommon
    ];
in {
  # ============================================================================
  # 1. PYTHON SHELL (Jupyter + Data Science + Browser Autocomplete)
  # ============================================================================
  python = pkgs.mkShell {
    name = "python-data-science";

    buildInputs = with pkgs; [
      bashInteractive

      # The Python Environment
      (python3.withPackages (ps:
        with ps; [
          # Core
          pip
          virtualenv
          poetry

          # Data Science (Requested)
          numpy
          pandas
          matplotlib

          # Jupyter & IDE Features (Browser based)
          jupyterlab # The IDE
          jupyterlab-lsp # The "Plugin" for autocompletion in browser
          python-lsp-server # The "Brain" (replacement for Pylance)
        ]))
    ];

    # Link system C-libraries so Pandas/Numpy run correctly
    LD_LIBRARY_PATH = lib-path;

    shellHook = ''
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "🐍 Python Data Science Environment"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "Commands:"
      echo "  jupyter lab   -> Open IDE in browser"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    '';
  };
}
