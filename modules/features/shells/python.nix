{
  perSystem = {pkgs, ...}: {
    devShells.python = pkgs.mkShell {
      name = "python-dev";

      packages = with pkgs; [
        python312
        uv
        python312Packages.pytest
        python312Packages.debugpy
        python312Packages.ipython
        httpie
        jq
      ];

      shellHook = ''
        export PYTHONUNBUFFERED=1
        export PYTHONDONTWRITEBYTECODE=1

        cat <<'PYTHON_DEV_TOOLS'

        Python development shell
        ========================

        Installed tools:
          python312       Python 3.12 interpreter
          uv              Python package and environment manager
          pytest          Python test runner
          debugpy         Python debugger
          ipython         Enhanced interactive Python shell
          httpie          HTTP client for testing APIs
          jq              JSON parser and command-line processor

        IDE tooling (provided by Home Manager / Helix):
          pyright         Python autocomplete, type checking and navigation
          ruff            Python linting and code formatting

        Quick start:
          python script.py
          uv run --with requests script.py
          uv init my-project
          uv add fastapi
          uv run pytest
          hx script.py

        PYTHON_DEV_TOOLS

        echo "Python: $(python --version)"
        echo "uv: $(uv --version)"
      '';
    };
  };
}
