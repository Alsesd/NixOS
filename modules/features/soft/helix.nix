{
  flake.nixosModules.helix = {
    pkgs,
    vars,
    ...
  }: {
    home-manager.users.${vars.username} = {
      programs.helix = {
        enable = true;
        defaultEditor = false;

        settings = {
          theme = "default";

          editor = {
            line-number = "relative";
            cursorline = true;
            color-modes = true;
            bufferline = "multiple";

            # IDE-style completion while typing.
            auto-completion = true;
            auto-info = true;
            completion-trigger-len = 2;
            completion-replace = true;
            idle-timeout = 250;

            # Snippets and useful editing behavior.
            auto-save = false;
            auto-format = true;
            trim-trailing-whitespace = true;
            insert-final-newline = true;

            indent-guides = {
              render = true;
              character = "┊";
            };

            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };

            lsp = {
              display-messages = true;
              display-inlay-hints = true;
              auto-signature-help = true;
            };
          };

          keys.normal = {
            # Save and navigate buffers.
            "C-s" = ":write";
            "C-w" = ":buffer-close";
            "C-p" = "file_picker";
            "C-r" = "global_search";

            # Code intelligence.
            "g" = {
              a = "code_action";
              d = "goto_definition";
              D = "goto_declaration";
              r = "goto_reference";
              i = "goto_implementation";
              t = "goto_type_definition";
            };

            # Convenient diagnostics navigation.
            "]" = {
              d = "goto_next_diag";
            };
            "[" = {
              d = "goto_prev_diag";
            };
          };

          keys.insert = {
            "C-s" = [
              "normal_mode"
              ":write"
            ];
            "C-space" = "completion";
            "C-e" = "completion";
          };
        };

        languages = {
          language-server = {
            pyright = {
              command = "pyright-langserver";
              args = ["--stdio"];
              config = {
                python.analysis = {
                  typeCheckingMode = "basic";
                  autoImportCompletions = true;
                  diagnosticMode = "workspace";
                };
              };
            };

            ruff = {
              command = "ruff";
              args = ["server"];
            };

            nixd = {
              command = "nixd";
            };

            docker-langserver = {
              command = "docker-langserver";
              args = ["--stdio"];
            };

            yaml-language-server = {
              command = "yaml-language-server";
              args = ["--stdio"];
            };
          };

          language = [
            {
              name = "python";
              language-servers = ["pyright" "ruff"];
              auto-format = true;
              formatter = {
                command = "ruff";
                args = [
                  "format"
                  "--stdin-filename"
                  "%{buffer_name}"
                  "-"
                ];
              };
            }

            {
              name = "nix";
              language-servers = ["nixd"];
              auto-format = true;
              formatter = {
                command = "alejandra";
              };
            }

            {
              name = "dockerfile";
              language-servers = ["docker-langserver"];
            }

            {
              name = "yaml";
              language-servers = ["yaml-language-server"];
            }

            {
              name = "git-commit";
              language-servers = [];
            }
          ];
        };
      };

      programs.lazygit.enable = true;

      programs.git = {
        enable = true;

        extraConfig = {
          fetch.prune = true;
          init.defaultBranch = "main";
          pull.rebase = true;
          core.editor = "hx";
        };

        aliases = {
          st = "status -sb";
          lg = "log --oneline --graph --decorate -20";
          br = "branch -vv";
          unstage = "restore --staged";
          last = "log -1 HEAD --stat";
        };
      };

      programs.fish.shellAliases = {
        lg = "lazygit";
        gs = "git st";
        gl = "git lg";
        gbr = "git br";
        hxconf = "hx ~/.config/helix/config.toml";
        hxkeys = "hx ~/.config/helix/KEYS.md";
      };

      programs.fzf = {
        enable = true;
        enableFishIntegration = true;
      };

      # Thunar's terminal helper configuration.
      # Keep this only if you have verified that Kitty works with exo-open.
      xdg.configFile."xfce4/helpers.rc".text = ''
        TerminalEmulator=kitty
      '';

      xdg.configFile."helix/KEYS.md".text = ''
        # Helix quick reference

        ## Modes and editing
        i           Insert before cursor
        a           Insert after cursor
        Esc         Normal mode
        v           Select
        y           Yank (copy)
        p           Paste
        d           Delete selection
        u           Undo
        U           Redo
        x           Select line

        ## Navigation
        h j k l     Move left/down/up/right
        w / b       Next / previous word
        gg           First line
        G            Last line
        /            Search
        n / N        Next / previous match

        ## Files
        Space f      File picker
        Space b      Buffer picker
        Space /      Search project
        Ctrl+p       File picker (configured)
        Ctrl+r       Project search (configured)

        ## Code intelligence
        Ctrl+Space   Trigger completion in insert mode
        g d          Go to definition
        g r          Find references
        g i          Go to implementation
        g a          Code actions
        ] d          Next diagnostic
        [ d          Previous diagnostic

        ## Commands
        :w           Save
        :q           Quit
        :wq          Save and quit
        :format      Format buffer
        :tutor       Interactive tutorial
        :config-open Open Helix configuration
        ?            Help
      '';

      home.packages = with pkgs; [
        # Python / FastAPI development
        pyright
        ruff
        uv
        python3
        python3Packages.pytest
        python3Packages.debugpy
        python3Packages.ipython
        httpie
        jq

        # Docker and configuration files
        dockerfile-language-server-nodejs
        yaml-language-server

        # Git UI
        lazygit
      ];
    };
  };
}
