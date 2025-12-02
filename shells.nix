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
      poetry # Poetry is a standalone package, not python3Packages.poetry
      poetry # Poetry is a standalone package, not python3Packages.poetry
      vscode
      git
      dbeaver-bin
    ];
    shellHook = ''
            # Set custom shell name with Python icon
            export NIXSHELL_NAME=" python"

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
            # Set custom shell name with Nix snowflake icon
            export NIXSHELL_NAME="❄ nix"

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

# 3. JUPYTER SHELL (Data Science with notebooks – standalone JupyterLab IDE)
jupyter = pkgs.mkShell {
  buildInputs = with pkgs; [
    bashInteractive
    nodejs_22
    (python3.withPackages (ps:
      with ps; [
        # Core
        pip
        virtualenv

        # LSP for intelligent completions, hover, go-to-def, etc.
        python-lsp-server
        jupyter-lsp          # ← critical: Jupyter server extension for LSP
        jupyterlab-lsp       # ← frontend extension for JupyterLab

        # Jupyter
        jupyterlab
        notebook
        ipython
        ipykernel

        # Data Science Stack
        numpy
        pandas
        matplotlib
        scipy
        scikit-learn
        seaborn
        plotly
        statsmodels
        openpyxl
        xlrd
        sqlalchemy
        faker
        requests
        beautifulsoup4
      ]))
    git
    dbeaver-bin  # keep if you use it for DBs
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
    # Set custom shell name
    export NIXSHELL_NAME="📊 jupyter"

    # Skip extra setup if inside VSCode terminal (harmless but clean)
    if [[ -n "$VSCODE_IPC_HOOK_CLI" ]] || [[ "$TERM_PROGRAM" == "vscode" ]]; then
      return 0
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📊 Standalone JupyterLab IDE (LSP Enabled)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Use local config dir to avoid polluting home - CORRECTED ESCAPING
    export XDG_CONFIG_HOME="\$PWD/.config"
    mkdir -p "$XDG_CONFIG_HOME/jupyter"

    # Enable Python LSP in Jupyter
    cat > "$XDG_CONFIG_HOME/jupyter/jupyter_server_config.py" << 'EOF'
c.LanguageServerManager.language_servers = {
    'python-lsp-server': {
        'version': 2,
        'argv': ['python', '-m', 'pylsp'],
        'languages': ['python']
    }
}
EOF

    # Initialize Git if needed
    if [ ! -d .git ]; then
      echo "📝 Initializing Git repo..."
      git init -q
    fi

    # Create .gitignore if missing
    if [ ! -f .gitignore ]; then
      cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
.env
.venv/

# Jupyter
.ipynb_checkpoints/
*.ipynb_checkpoints

# Direnv
.direnv/

# Data
*.csv
*.db
*.sqlite
*.sqlite3

# OS
.DS_Store
Thumbs.db
EOF
    fi

    # Create .envrc for direnv - POINT TO YOUR ACTUAL FLAKE
    if [ ! -f .envrc ]; then
      echo "use flake ~/.config/nixos#jupyter" > .envrc
      echo "⚠️  Run 'direnv allow' to auto-activate this shell"
    fi

    echo ""
    echo "🐍 Python: $(python --version)"
    echo "📊 JupyterLab: $(jupyter --version 2>/dev/null | head -n1)"
    echo ""
    echo "✅ LSP-powered IDE features enabled:"
    echo "   • Autocompletion (with signatures)"
    echo "   • Hover documentation"
    echo "   • Go to definition (Ctrl+Click)"
    echo "   • Real-time diagnostics"
    echo ""
    echo "🚀 Run 'jupyter lab' to start"
    echo ""
  '';
};
