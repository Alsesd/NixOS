{pkgs, ...}: {
  home.packages = [
    pkgs.neovim
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;

    plugins = with pkgs.vimPlugins; [
      pkgs.vimPlugins.LazyVim
      vim-nix
      nvim-treesitter
      plenary-nvim
      telescope-nvim
      nvim-lspconfig
      #mason-nvim
      #mason-lspconfig-nvim
      cmp-nvim-lsp
      nvim-cmp
      friendly-snippets
      cmp-buffer
      cmp-path
      cmp-vsnip
    ];

    extraConfig = ''
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "nix", "lua", "python", "bash", "json", "yaml", "markdown" };
        highlight = {
          enable = true;
        };
      }
    '';
  };
}
