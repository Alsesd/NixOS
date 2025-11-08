{pkgs}: {
  # Python dev environment
  python = pkgs.mkShell {
    buildInputs = with pkgs; [
      bashInteractive # Full bash with completion support
      python3
      python3Packages.pip
      python3Packages.virtualenv
      vscode
      git
      python3Packages.python-lsp-server
      python3Packages.pylint
      python3Packages.black
    ];

    shellHook = ''
            # Enable bash completion
            if [ -f /etc/bash_completion ]; then
              . /etc/bash_completion
            fi

            # Create venv if needed (always)
            [ ! -d .venv ] && python -m venv .venv
            source .venv/bin/activate
            pip install --upgrade pip --quiet 2>/dev/null

            # Skip fancy output and VSCode opening if already in VSCode terminal
            if [[ -n "$VSCODE_IPC_HOOK_CLI" ]] || [[ "$TERM_PROGRAM" == "vscode" ]]; then
              return 0
            fi


            PROJECT_NAME=$(basename "$(pwd)")
            WORKSPACE_FILE="$PROJECT_NAME.code-workspace"

            # Create virtual environment if it doesn't exist
            if [ ! -d .venv ]; then
              echo "🔧 Creating virtual environment..."
              python -m venv .venv
            fi

            # Activate the virtual environment
            source .venv/bin/activate

            # Upgrade pip silently
            pip install --upgrade pip --quiet 2>/dev/null

            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "🐍 Python Environment: $PROJECT_NAME"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

            # Check if workspace file exists
            if [ -f "$WORKSPACE_FILE" ]; then
              echo "📂 Found workspace: $WORKSPACE_FILE"
              echo "🚀 Opening VSCode..."
              code "$WORKSPACE_FILE" 2>/dev/null &
            else
              echo "📝 Creating workspace: $WORKSPACE_FILE"

              cat > "$WORKSPACE_FILE" << 'EOF'
      {
        "folders": [
          {
            "path": "."
          }
        ],
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
          "files.watcherExclude": {
            "**/.venv/**": true
          }
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
              echo "🚀 Opening VSCode..."
              code "$WORKSPACE_FILE" 2>/dev/null &
            fi

            # Initialize git repo if not exists
            if [ ! -d .git ]; then
              echo "📝 Initializing git repository..."
              git init
              git add .gitignore 2>/dev/null || true
            fi

            # Create .gitignore if it doesn't exist
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

      # direnv
      .direnv/

      # Distribution / packaging
      dist/
      build/
      *.egg-info/

      # Testing
      .pytest_cache/
      .coverage

      # VSCode
      .vscode/
      EOF
            fi

            # Create .envrc if it doesn't exist
            if [ ! -f .envrc ]; then
              echo "📝 Creating .envrc..."
              cat > .envrc << 'EOF'
      use flake /etc/nixos#python
      EOF
              echo "⚠️  Run 'direnv allow' to enable automatic activation"
            fi

            echo ""
            echo "Python: $(python --version)"
            echo "pip: $(pip --version)"

            # Optional: Auto-close if requested
            if [[ "$AUTO_CLOSE" == "true" ]]; then
              echo "👋 Closing terminal (AUTO_CLOSE=true)"
              sleep 1
              exit
            fi

            echo "💡 Tip: Add 'export AUTO_CLOSE=true' to .envrc to auto-close terminal"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    '';
  };

  # Nix development environment
  nix = pkgs.mkShell {
    buildInputs = with pkgs; [
      bashInteractive # Full bash with completion support
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
            # Skip fancy output and VSCode opening if already in VSCode terminal
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
              echo "🚀 Opening VSCode..."
              code "$WORKSPACE_FILE" 2>/dev/null &
            else
              echo "📝 Creating workspace: $WORKSPACE_FILE"

              cat > "$WORKSPACE_FILE" << 'EOF'
      {
        "folders": [
          {
            "path": "."
          }
        ],
        "settings": {
          "nix.enableLanguageServer": true,
          "nix.serverPath": "nil",
          "nix.formatterPath": "alejandra",
          "[nix]": {
            "editor.defaultFormatter": "jnoortheen.nix-ide",
            "editor.formatOnSave": true,
            "editor.tabSize": 2
          },
          "files.associations": {
            "*.nix": "nix"
          },
          "editor.formatOnSave": true,
          "files.exclude": {
            "result": true,
            "result-*": true
          }
        },
        "extensions": {
          "recommendations": [
            "jnoortheen.nix-ide",
            "arrterian.nix-env-selector"
          ]
        }
      }
      EOF

              echo "✅ Workspace created"
              echo "🚀 Opening VSCode..."
              code "$WORKSPACE_FILE" 2>/dev/null &
            fi

            # Initialize git repo if not exists
            if [ ! -d .git ]; then
              echo "📝 Initializing git repository..."
              git init
              git add .gitignore 2>/dev/null || true
            fi

            if [ ! -f .gitignore ]; then
              echo "📝 Creating .gitignore..."
              cat > .gitignore << 'EOF'
      # Nix
      result
      result-*

      # direnv
      .direnv/

      # VSCode
      .vscode/
      EOF
            fi

            if [ ! -f .envrc ]; then
              echo "📝 Creating .envrc..."
              cat > .envrc << 'EOF'
      use flake /etc/nixos#nix
      EOF
              echo "⚠️  Run 'direnv allow' to enable automatic activation"
            fi

            echo ""
            echo "Nix tools available:"
            echo "  nil (language server): $(which nil)"
            echo "  alejandra (formatter): $(which alejandra)"
            echo "  statix (linter): $(which statix)"
            echo "  git: $(git --version)"

            # Optional: Auto-close if requested
            if [[ "$AUTO_CLOSE" == "true" ]]; then
              echo "👋 Closing terminal (AUTO_CLOSE=true)"
              sleep 1
              exit
            fi

            echo "💡 Tip: Add 'export AUTO_CLOSE=true' to .envrc to auto-close terminal"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    '';
  };
}
