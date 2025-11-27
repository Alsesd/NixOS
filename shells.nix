{pkgs}: {
  # 1. PYTHON SHELL (Lightweight for scripting and general development)
  python = pkgs.mkShell {
    buildInputs = with pkgs; [
      bashInteractive
      python3
      python3Packages.pip
      python3Packages.virtualenv
      python3Packages.python-lsp-server
      python3Packages.pylint
      python3Packages.black
      python3Packages.poetry
      python3Packages.poetry-core
      vscode
      git
      dbeaver-bin
    ];
    shellHook = ''
            # Enable bash completion
            if [ -f /etc/bash_completion ]; then
              . /etc/bash_completion
            fi

            if [[ -n "$VSCODE_IPC_HOOK_CLI" ]] || [[ "$TERM_PROGRAM" == "vscode" ]]; then
              return 0
            fi

            PROJECT_NAME=$(basename "$(pwd)")
            WORKSPACE_FILE="$PROJECT_NAME.code-workspace"

            # Create venv if needed
            if [ ! -d .venv ]; then
              echo "🔧 Creating virtual environment..."
              python -m venv .venv
            fi
            source .venv/bin/activate
            pip install --upgrade pip --quiet 2>/dev/null

            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "🐍 Python Development Environment"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

            if [ -f "$WORKSPACE_FILE" ]; then
              echo "📂 Found workspace: $WORKSPACE_FILE"
              echo "🚀 Opening VSCode (maximized)..."
              code "$WORKSPACE_FILE" --maximize 2>/dev/null &
            else
              echo "📝 Creating workspace: $WORKSPACE_FILE"
              cat > "$WORKSPACE_FILE" << 'EOF'
      {
        "folders": [{"path": "."}],
        "settings": {
          "python.defaultInterpreterPath": "''${workspaceFolder}/.venv/bin/python",
          "python.terminal.activateEnvironment": true,
          "python.analysis.autoImportCompletions": true,
          "python.analysis.typeCheckingMode": "basic",
          "python.linting.enabled": true,
          "python.linting.pylintEnabled": true,
          "python.formatting.provider": "black",
          "editor.formatOnSave": true,
          "files.exclude": {
            "**/__pycache__": true,
            "**/*.pyc": true,
            ".venv": false
          },
          "files.watcherExclude": { "**/.venv/**": true }
        },
        "extensions": {
          "recommendations": [
            "ms-python.python",
            "ms-python.vscode-pylance",
            "ms-python.black-formatter"
          ]
        }
      }
      EOF
              echo "✅ Workspace created"
              echo "🚀 Opening VSCode (maximized)..."
              code "$WORKSPACE_FILE" --maximize 2>/dev/null &
            fi

            if [ ! -d .git ]; then
              echo "📝 Initializing git repository..."
              git init
              git add .gitignore 2>/dev/null || true
            fi

            if [ ! -f .gitignore ]; then
              echo "📝 Creating .gitignore..."
              cat > .gitignore << 'EOF'
      # Python
      .venv/
      __pycache__/
      *.py[cod]
      *$py.class
      *.so
      .Python
      build/
      dist/
      *.egg-info/
      # Poetry
      poetry.lock
      # direnv
      .direnv/
      # VSCode
      .vscode/
      # Data
      *.db
      *.sqlite
      *.sqlite3
      EOF
            fi

            if [ ! -f .envrc ]; then
              echo "📝 Creating .envrc..."
              cat > .envrc << 'EOF'
      use flake ~/.config/nixos#python
      EOF
              echo "⚠️  Run 'direnv allow' to enable automatic activation"
            fi

            echo ""
            echo "Python: $(python --version)"
            echo "Poetry: $(poetry --version 2>/dev/null || echo 'available')"
            echo ""
            echo "💡 Use 'pip install <package>' for additional packages"
            echo "💡 Use 'poetry init' to start a Poetry project"

            if [[ "$AUTO_CLOSE" == "true" ]]; then
              echo "👋 Closing terminal (AUTO_CLOSE=true)"
              sleep 1
              exit
            fi
    '';
  };

  # 2. NIX SHELL
  nix = pkgs.mkShell {
    buildInputs = with pkgs; [
      bashInteractive
      nil
      nixd
      nixpkgs-fmt
      alejandra
      statix
      deadnix
      vscode
      git
      tree
      jq
    ];
    shellHook = ''
            if [[ -n "$VSCODE_IPC_HOOK_CLI" ]] || [[ "$TERM_PROGRAM" == "vscode" ]]; then
              return 0
            fi

            PROJECT_NAME=$(basename "$(pwd)")
            WORKSPACE_FILE="$PROJECT_NAME.code-workspace"

            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "❄️  Nix Development Environment: $PROJECT_NAME"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

            if [ -f "$WORKSPACE_FILE" ]; then
              echo "📂 Found workspace: $WORKSPACE_FILE"
              echo "🚀 Opening VSCode (maximized)..."
              code "$WORKSPACE_FILE" --maximize 2>/dev/null &
            else
              echo "📝 Creating workspace: $WORKSPACE_FILE"
              cat > "$WORKSPACE_FILE" << 'EOF'
      {
        "folders": [{"path": "."}],
        "settings": {
          "nix.enableLanguageServer": true,
          "nix.serverPath": "nil",
          "nix.formatterPath": "alejandra",
          "[nix]": {
            "editor.defaultFormatter": "jnoortheen.nix-ide",
            "editor.formatOnSave": true,
            "editor.tabSize": 2
          },
          "files.associations": { "*.nix": "nix" },
          "editor.formatOnSave": true,
          "files.exclude": { "result": true, "result-*": true }
        },
        "extensions": { "recommendations": ["jnoortheen.nix-ide", "arrterian.nix-env-selector"] }
      }
      EOF
              echo "✅ Workspace created"
              echo "🚀 Opening VSCode (maximized)..."
              code "$WORKSPACE_FILE" --maximize 2>/dev/null &
            fi

            if [ ! -f .envrc ]; then
              echo "use flake ~/.config/nixos#nix" > .envrc
              echo "⚠️  Run 'direnv allow'"
            fi
    '';
  };

  # 3. JUPYTER SHELL (Data Science with notebooks)
  jupyter = pkgs.mkShell {
    buildInputs = with pkgs; [
      bashInteractive
      nodejs_22
      (python3.withPackages (ps:
        with ps; [
          pip
          virtualenv
          python-lsp-server
          # Jupyter
          jupyterlab
          jupyterlab-lsp
          ipython
          ipykernel
          notebook
          # Data Science Core
          numpy
          pandas
          matplotlib
          scipy
          scikit-learn
          seaborn
          plotly
          # Additional Tools
          statsmodels
          openpyxl
          xlrd
          sqlalchemy
          faker
          requests
          beautifulsoup4
        ]))
      vscode
      git
      dbeaver-bin
    ];

    LD_LIBRARY_PATH = with pkgs;
      lib.makeLibraryPath [
        stdenv.cc.cc
        zlib
        glib
        glibc
        libGL
        libxkbcommon
      ];

    shellHook = ''
      if [[ -n "$VSCODE_IPC_HOOK_CLI" ]] || [[ "$TERM_PROGRAM" == "vscode" ]]; then
        return 0
      fi

      PROJECT_NAME=$(basename "$(pwd)")
      WORKSPACE_FILE="$PROJECT_NAME.code-workspace"

      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "📊 Jupyter Lab (Data Science)"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

      if [ -f "$WORKSPACE_FILE" ]; then
        echo "📂 Found workspace: $WORKSPACE_FILE"
        echo "🚀 Opening VSCode (maximized)..."
        code "$WORKSPACE_FILE" --maximize 2>/dev/null &
      else
        echo "📝 Creating workspace: $WORKSPACE_FILE"
        cat > "$WORKSPACE_FILE" << 'EOF'
      {
        "folders": [{"path": "."}],
        "settings": {
          "python.defaultInterpreterPath": "$(which python)",
          "jupyter.notebookFileRoot": "''${workspaceFolder}",
          "notebook.cellToolbarLocation": {
            "default": "right",
            "jupyter-notebook": "left"
          },
          "files.exclude": {
            "**/__pycache__": true,
            "**/*.pyc": true,
            ".ipynb_checkpoints": true
          }
        },
        "extensions": {
          "recommendations": [
            "ms-python.python",
            "ms-python.vscode-pylance",
            "ms-toolsai.jupyter",
            "ms-toolsai.jupyter-keymap",
            "ms-toolsai.jupyter-renderers"
          ]
        }
      }
      EOF
        echo "✅ Workspace created"
        echo "🚀 Opening VSCode (maximized)..."
        code "$WORKSPACE_FILE" --maximize 2>/dev/null &
      fi

      if [ ! -d .git ]; then
        echo "📝 Initializing git repository..."
        git init
        git add .gitignore 2>/dev/null || true
      fi

      if [ ! -f .gitignore ]; then
        echo "📝 Creating .gitignore..."
        cat > .gitignore << 'EOF'
      # Python
      __pycache__/
      *.py[cod]
      *$py.class
      *.so
      .Python
      # Jupyter
      .ipynb_checkpoints/
      *.ipynb_checkpoints
      # direnv
      .direnv/
      # VSCode
      .vscode/
      # Data
      *.csv
      *.db
      *.sqlite
      *.sqlite3
      EOF
      fi

      if [ ! -f .envrc ]; then
        echo "use flake ~/.config/nixos#jupyter" > .envrc
        echo "⚠️  Run 'direnv allow'"
      fi

      echo ""
      echo "Python: $(python --version)"
      echo "Jupyter: $(jupyter --version 2>&1 | head -n1)"
      echo ""
      echo "💡 Run 'jupyter lab' to start Jupyter Lab"
      echo "💡 All data science packages are pre-installed"
    '';
  };
}
