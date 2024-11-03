{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.test;
in {
  options.vim.test = {
    enable = mkEnableOption "Enable unit test support";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      vim-test
    ];

    vim.nnoremap = {
      "<leader>T" = "<cmd>TestSuite<CR>";
    };

    vim.configRC = ''
      let test#strategy = "${
        if config.vim.editor.floaterm
        then "floaterm"
        else "neovim"
      }"
    '';
  };
}
