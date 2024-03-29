{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Functionality
      telescope-nvim
      (nvim-treesitter.withPlugins (p: [ p.javascript p.typescript p.c p.lua p.vim p.vimdoc p.query p.c_sharp p.nix p.org ]))
      harpoon
      undotree
      vim-fugitive 
      orgmode

      lsp-zero-nvim
      # LSP Support
      nvim-lspconfig

      # Autocompletion
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp_luasnip
      cmp-nvim-lsp
      cmp-nvim-lua

      # Snippits
      luasnip
      friendly-snippets

      # Visuals
      tokyonight-nvim
      lualine-nvim
    ];
    extraPackages = with pkgs; [
      nil
      alejandra
      typescript
      nodePackages_latest.eslint
      lua-language-server 
      rust-analyzer
      omnisharp-roslyn
    ];
  };

  xdg.configFile.nvim.source = ./nvim;
}
