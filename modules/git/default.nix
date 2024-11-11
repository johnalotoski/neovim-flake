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
    vim.startPlugins = with pkgs.neovimPlugins;
      [gitsigns-nvim splice] ++ (optional cfg.blameLine nvim-blame-line);

    vim.configRC = optionalString cfg.blameLine ''
      autocmd BufEnter * EnableBlameLine
    '';

    vim.luaConfigRC = ''
      require('gitsigns').setup()

      -- Add any additional which-key bindings here
      -- ${optionalString config.vim.editor.whichKey ''
        --   require("which-key").add({
        --   })
        -- ''}
    '';
  };
}
