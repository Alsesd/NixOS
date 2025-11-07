{
  description = "My favourite NixOS";

  # INPUTS: External dependencies your flake uses
  inputs = {
    # Main package repository (unstable = latest packages)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home-manager: Manages user-level configs (dotfiles, packages, etc.)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Use same nixpkgs version
    };

    # Stylix: System-wide theming (colors, fonts, etc.)
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs"; # Use same nixpkgs version
    };
  };

  # OUTPUTS: What your flake produces
  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # Define system architecture
    system = "x86_64-linux";

    # Import nixpkgs with configuration
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true; # Allow proprietary software (Discord, Steam, etc.)
    };
  in {
    # NIXOS SYSTEM CONFIGURATION
    nixosConfigurations = {
      # "myNixos" is your hostname - change if needed
      myNixos = nixpkgs.lib.nixosSystem {
        # Pass inputs and system to modules
        specialArgs = {inherit inputs system;};

        modules = [
          # System configuration (packages, services, etc.)
          ./configuration.nix

          # Hardware-specific config (filesystems, boot, etc.)
          ./system_info/hardware-configuration.nix

          # Enable Stylix theming module
          inputs.stylix.nixosModules.stylix

          # Enable home-manager as NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              # User configuration (username must match your actual user)
              users.alsesd = import ./home.nix;
            };
          }
        ];
      };

      # DEVELOPMENT SHELLS (separate from nixosConfigurations!)
      devShells.${system} = {
        # Python dev environment with pip support and VSCode launcher
        python = pkgs.mkShell {
          buildInputs = with pkgs; [
            python3
            python3Packages.pip
            python3Packages.virtualenv
          ];

          shellHook = ''
                     # Create virtual environment if it doesn't exist
                     if [ ! -d .venv ]; then
                       echo "Creating virtual environment..."
                       python -m venv .venv
                     fi

                     # Activate the virtual environment
                     source .venv/bin/activate

                     # Upgrade pip
                     pip install --upgrade pip
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                     echo "🐍 Python Development Environment Ready"
                     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                     echo "Python: $(which python)"
                     echo "pip: $(which pip)"
                     echo ""

                     # Check if a workspace file is specified
                     if [ -n "$VSCODE_WORKSPACE" ] && [ -f "$VSCODE_WORKSPACE" ]; then
                       echo "🚀 Opening VSCode with workspace: $VSCODE_WORKSPACE"
                       code "$VSCODE_WORKSPACE" &
                     elif [ -f "$(pwd)/*.code-workspace" ]; then
                       # Auto-detect workspace file in current directory
                       WORKSPACE=$(ls *.code-workspace 2>/dev/null | head -n 1)
                       if [ -n "$WORKSPACE" ]; then
                         echo "🚀 Opening VSCode with detected workspace: $WORKSPACE"
                         code "$WORKSPACE" &
                       else
                         echo "💡 Tip: Open VSCode with 'code .' or set VSCODE_WORKSPACE"
                       fi
                     else
                       echo "💡 Tip: Open VSCode with 'code .'"
                       echo "    Or set VSCODE_WORKSPACE=/path/to/workspace.code-workspace"
                     fi

                     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          '';
        };
      };
    };
  };
}
