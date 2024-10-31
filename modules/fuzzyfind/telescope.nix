{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.fuzzyfind.telescope;
in {
  options.vim.fuzzyfind.telescope = {
    enable = mkEnableOption "Enable telescope";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-telescope
      plenary-nvim
    ];

    vim.nnoremap = {
      "<leader>ff" = "<cmd>Telescope find_files<cr>";
      "<leader>pf" = "<cmd>Telescope find_files<cr>";
      "<leader>fg" = "<cmd>Telescope live_grep<cr>";
      "<leader>p/" = "<cmd>Telescope live_grep<cr>";
      "<leader>fb" = "<cmd>Telescope buffers<cr>";
      "<leader>fh" = "<cmd>Telescope help_tags<cr>";
      "<C-p>" = "<cmd>Telescope find_files<cr>";
    };
  };
}
