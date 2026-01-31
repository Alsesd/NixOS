{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      cursorline = true;
      termguicolors = true;
      mouse = "a";
      clipboard = "unnamedplus";
      ignorecase = true;
      smartcase = true;
      undofile = true;
    };

    globals.mapleader = " ";

    plugins = {
      web-devicons.enable = true;

      noice = {
        enable = true;
        settings.presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
        };
      };

      which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed-1 = "<leader>f";
            group = "Files/Find";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "Search";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "Code/LSP";
          }
          {
            __unkeyed-1 = "<leader>b";
            group = "Buffers";
          }
        ];
      };

      lualine.enable = true;
      bufferline.enable = true;

      neo-tree = {
        enable = true;
        settings.close_if_last_window = true;
        settings.filesystem.follow_current_file.enabled = true;
      };

      telescope.enable = true;

      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          pyright.enable = true;
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
          ];
          mapping = {
            "<Tab>" = "cmp.mapping.confirm({ select = true })";
            "<Down>" = "cmp.mapping.select_next_item()";
            "<Up>" = "cmp.mapping.select_prev_item()";
          };
        };
      };

      none-ls = {
        enable = true;
        sources = {
          formatting.alejandra.enable = true;
          formatting.black.enable = true;
          diagnostics.deadnix.enable = true;
        };
      };

      treesitter.enable = true;
      gitsigns.enable = true;

      alpha = {
        enable = true;
        # FIXED: Changed from 'layout' to 'settings.layout'
        settings.layout = [
          {
            type = "padding";
            val = 2;
          }
          {
            type = "text";
            val = [
              "   ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗ "
              "   ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║ "
              "   ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║ "
              "   ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║ "
              "   ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║ "
              "   ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ "
            ];
            opts = {
              hl = "AlphaHeader";
              position = "center";
            };
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "group";
            val = [
              {
                type = "button";
                val = "  Find File";
                on_press.__raw = "function() require('telescope.builtin').find_files() end";
                opts = {
                  shortcut = "f";
                  keymap = [
                    "n"
                    "f"
                    "<cmd>Telescope find_files<CR>"
                    {
                      noremap = true;
                      silent = true;
                    }
                  ];
                };
              }
              {
                type = "button";
                val = "  Recent Files";
                on_press.__raw = "function() require('telescope.builtin').oldfiles() end";
                opts = {
                  shortcut = "r";
                  keymap = [
                    "n"
                    "r"
                    "<cmd>Telescope oldfiles<CR>"
                    {
                      noremap = true;
                      silent = true;
                    }
                  ];
                };
              }
              {
                type = "button";
                val = "  Find Text";
                on_press.__raw = "function() require('telescope.builtin').live_grep() end";
                opts = {
                  shortcut = "g";
                  keymap = [
                    "n"
                    "g"
                    "<cmd>Telescope live_grep<CR>"
                    {
                      noremap = true;
                      silent = true;
                    }
                  ];
                };
              }
              {
                type = "button";
                val = "  Config";
                on_press.__raw = "function() vim.cmd('cd ~/.config/nixos | e flake.nix') end";
                opts = {
                  shortcut = "c";
                  keymap = [
                    "n"
                    "c"
                    "<cmd>cd ~/.config/nixos | e flake.nix<CR>"
                    {
                      noremap = true;
                      silent = true;
                    }
                  ];
                };
              }
              {
                type = "button";
                val = "  Quit";
                on_press.__raw = "function() vim.cmd('qa') end";
                opts = {
                  shortcut = "q";
                  keymap = [
                    "n"
                    "q"
                    "<cmd>qa<CR>"
                    {
                      noremap = true;
                      silent = true;
                    }
                  ];
                };
              }
            ];
          }
        ];
      };
    };

    keymaps = [
      # Explorer
      {
        mode = "n";
        key = "<C-n>";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Explorer";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Explorer";
      }

      # Telescope
      {
        mode = "n";
        key = "<leader><space>";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find Files (Root)";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>Telescope oldfiles<CR>";
        options.desc = "Recent Files";
      }
      {
        mode = "n";
        key = "<leader>sg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Grep Search";
      }
      {
        mode = "n";
        key = "<leader>sb";
        action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
        options.desc = "Search in Buffer";
      }

      # Buffers
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>bd<CR>";
        options.desc = "Close Buffer";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<CR>";
        options.desc = "Prev Buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<CR>";
        options.desc = "Next Buffer";
      }

      # Code/LSP
      {
        mode = "n";
        key = "<leader>cf";
        action = "<cmd>lua vim.lsp.buf.format()<CR>";
        options.desc = "Format Code";
      }
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        options.desc = "Go to Definition";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Hover Docs";
      }
    ];

    extraConfigLua = ''
      require("noice").setup()
    '';
  };
}
