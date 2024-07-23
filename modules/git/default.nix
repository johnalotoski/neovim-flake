{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.git;
in {
  options.vim.git = {
    enable = mkEnableOption "Enable git support";
    blameLine = mkEnableOption "Prints blame info of who edited the line you are on.";
  };

  config = mkIf cfg.enable {
    vim.nnoremap = {"<leader>g" = "<cmd>MagitOnly<cr>";};

    vim.startPlugins = with pkgs.neovimPlugins;
      [gitsigns-nvim splice vimagit] ++ (optional cfg.blameLine nvim-blame-line);

    vim.configRC = optionalString cfg.blameLine ''
      autocmd BufEnter * EnableBlameLine
    '';

    vim.luaConfigRC = ''
      require('gitsigns').setup()
    '';
  };
}
