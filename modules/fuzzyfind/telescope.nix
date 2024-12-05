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

    vim.luaConfigRC = optionalString config.vim.editor.whichKey ''
      require("which-key").add({
        { "<leader>f", group = "Telescope" },
        { "<leader>fb", desc = "buffers" },
        { "<leader>ff", desc = "findFiles" },
        { "<leader>fg", desc = "grepFiles" },
        { "<leader>fh", desc = "helpTags" },
      })
    '';

    vim.nnoremap = {
      "<leader>ff" = "<cmd>Telescope find_files<CR>";
      "<leader>fg" = "<cmd>Telescope live_grep<CR>";
      "<leader>fb" = "<cmd>Telescope buffers<CR>";
      "<leader>fh" = "<cmd>Telescope help_tags<CR>";
    };
  };
}
