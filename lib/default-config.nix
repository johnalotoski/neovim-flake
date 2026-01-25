lib: let
  inherit (lib) mkDefault;
in {
  config.vim = {
    dashboard.startify.customHeader = mkDefault ["Welcome to NeoVim"];
    dashboard.startify.enable = mkDefault true;
    database.enable = mkDefault true;
    disableArrows = mkDefault false;
    virtualedit = mkDefault "all";

    editor = {
      abolish = mkDefault true;
      colorPreview = mkDefault true;

      # Floaterm causes intermittent checkhealth issues due to race condition as of:
      # Ref: https://github.com/voldikss/vim-floaterm/commit/4e28c8dd0271e10a5f55142fb6fe9b1599ee6160
      floaterm = mkDefault false;

      # Might be nice to have starting from toggled off state
      indentGuide = mkDefault false;

      retabTabs = mkDefault true;
      showTabs = mkDefault true;
      showTrailingWhitespace = mkDefault true;
      spell = mkDefault true;
      surround = mkDefault true;
      trimTrailingWhitespace = mkDefault true;
      underlineCurrentWord = mkDefault true;
      whichKey = mkDefault true;
      wilder = mkDefault true;
    };

    filetree.nvimTreeLua = {enable = mkDefault true;};
    fuzzyfind.telescope.enable = mkDefault true;
    lineNumberMode = mkDefault "number";
    statusline.lightline.enable = mkDefault true;
    tabbar.barbar.enable = mkDefault true;
    test.enable = mkDefault true;
    theme.gruvbox.enable = mkDefault true;
    viAlias = mkDefault true;
    vimAlias = mkDefault true;

    git = {
      enable = mkDefault true;

      # Appears to no longer work
      blameLine = mkDefault false;
    };

    lsp = {
      enable = mkDefault true;

      bash = mkDefault true;
      clang = mkDefault true;
      cmake = mkDefault true;
      crystal = mkDefault true;
      css = mkDefault true;
      docker = mkDefault true;
      elixir = mkDefault true;
      fidget = mkDefault true;
      gleam = mkDefault true;
      go = mkDefault true;
      haskellLspConfig = mkDefault false;
      haskellTools = mkDefault true;
      html = mkDefault true;
      json = mkDefault true;
      lightbulb = mkDefault true;
      mint = mkDefault true;
      nickel = mkDefault true;
      nix = mkDefault true;
      nu = mkDefault true;
      python = mkDefault true;
      rego = mkDefault true;
      ruby = mkDefault true;
      rust = mkDefault true;
      shellcheck = mkDefault true;
      terraform = mkDefault true;
      tex = mkDefault true;
      typescript = mkDefault true;
      variableDebugPreviews = mkDefault true;
      vimscript = mkDefault true;
      yaml = mkDefault true;
      zig = mkDefault true;
    };

    cnoremap = {"3636" = "<c-u>undo<CR>";};

    # Barbar default mappings
    nnoremap = {
      # Move to previous/next
      "<silent> <A-,>" = "<Cmd>BufferPrevious<CR>";
      "<silent> <A-.>" = "<Cmd>BufferNext<CR>";

      # Re-order to previous/next
      "<silent> <A-<>" = "<Cmd>BufferMovePrevious<CR>";
      "<silent> <A->>" = "<Cmd>BufferMoveNext<CR>";

      # Pin/unpin buffer
      "<silent> <A-p>" = "<Cmd>BufferPin<CR>";

      # Close buffer
      "<silent> <A-c>" = "<Cmd>BufferClose<CR>";

      # Magic buffer-picking mode
      "<silent> <C-p>" = "<Cmd>BufferPick<CR>";
      "<silent> <C-A-p>" = "<Cmd>BufferPickDelete<CR>";

      # Sort automatically by...
      "<silent> <leader>bb" = "<Cmd>BufferOrderByBufferNumber<CR>";
      "<silent> <leader>bd" = "<Cmd>BufferOrderByDirectory<CR>";
      "<silent> <leader>bl" = "<Cmd>BufferOrderByLanguage<CR>";
      "<silent> <leader>bw" = "<Cmd>BufferOrderByWindowNumber<CR>";
    };
  };
}
