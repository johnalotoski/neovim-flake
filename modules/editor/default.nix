{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.editor;
in {
  options.vim.editor = {
    abolish = mkEnableOption "Enable vim-abolish";

    colourPreview = mkEnableOption "Enable colour previews";

    floaterm = mkEnableOption "Enable floaterm instead of built in";

    indentGuide = mkEnableOption "Enable indent guides";

    retabTabs = mkOption {
      description = "Retab tabs to convert to spaces automatically on save";
      type = types.bool;
      default = false;
    };

    showTabs = mkOption {
      description = "Show tabs in the showTabsColor value";
      type = types.bool;
      default = false;
    };

    showTabsColor = mkOption {
      description = ''
        The highlight color to show tabs with if showTabs is enabled.
        must be both cterm and gui color scheme compatible as shown by:
          :help ctermbg
          :help guibg
      '';
      type = types.str;
      default = "magenta";
    };

    showTrailingWhitespace = mkOption {
      description = "Show trailing whitespace in the showTrailingWhitespaceColor value";
      type = types.bool;
      default = false;
    };

    showTrailingWhitespaceColor = mkOption {
      description = ''
        The highlight color to show tabs with if showTrailingWhitespace is enabled.
        must be both cterm and gui color scheme compatible as shown by:
          :help ctermbg
          :help guibg
      '';
      type = types.str;
      default = "red";
    };

    spell = mkEnableOption "Enable spelling on startup ";

    spelllang = mkOption {
      description = "Set the default spelling language";
      type = types.str;
      default = "en";
    };

    surround = mkEnableOption "Enable vim-surround";

    trimTrailingWhitespace = mkOption {
      description = "Trim trailing whitespace on save";
      type = types.bool;
      default = false;
    };

    underlineCurrentWord = mkEnableOption "Underline the word under the cursor";

    whichKey = mkEnableOption "Enable Which key";

    wilder = mkEnableOption "Enable wilder.nvim";
  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins;
      (optional cfg.indentGuide indent-blankline-nvim)
      ++ (optional cfg.underlineCurrentWord vim-cursorword)
      ++ (optional cfg.whichKey which-key-nvim)
      ++ (optional cfg.floaterm vim-floaterm)
      ++ (optional cfg.surround vim-surround)
      ++ (optional cfg.wilder wilder-nvim)
      ++ (optional cfg.abolish vim-abolish);

    vim.nnoremap = {
      "<leader>?" = "<cmd>WhichKey '<Space>'<cr>";
      "<leader>p`" = "<cmd>FloatermNew<cr>";
      "<leader>`j" = "<cmd>FloatermNext<cr>";
      "<leader>`k" = "<cmd>FloatermPrev><cr>";
    };

    vim.configRC = ''
      "let g:Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla'"

      function s:MkNonExDir(file, buf)
        if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
          let dir=fnamemodify(a:file, ':h')
          if !isdirectory(dir)
            call mkdir(dir, 'p')
          endif
        endif
      endfunction

      augroup BWCCreateDir
        autocmd!
        autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
      augroup END

      ${optionalString cfg.wilder ''
        call wilder#enable_cmdline_enter()
        set wildcharm=<Tab>
        cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
        cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"
        call wilder#set_option('modes', ['/', '?', ':'])

        call wilder#set_option('pipeline', [
              \   wilder#branch(
              \     wilder#substitute_pipeline(),
              \     wilder#cmdline_pipeline({
              \       'fuzzy': 1,
              \       'sorter': wilder#python_difflib_sorter(),
              \     }),
              \     wilder#python_search_pipeline({
              \       'pattern': 'fuzzy',
              \     }),
              \   ),
              \ ])

        let s:highlighters = [
                \ wilder#pcre2_highlighter(),
                \ wilder#basic_highlighter(),
                \ ]

        call wilder#set_option('renderer', wilder#renderer_mux({
              \ ':': wilder#popupmenu_renderer({
              \   'highlighter': s:highlighters,
              \ }),
              \ '/': wilder#wildmenu_renderer({
              \   'highlighter': s:highlighters,
              \ }),
              \ }))
      ''}

      ${optionalString cfg.showTrailingWhitespace ''
        highlight ExtraWhitespace ctermbg=${cfg.showTrailingWhitespaceColor} guibg=${cfg.showTrailingWhitespaceColor}
        au ColorScheme * highlight ExtraWhitespace guibg=${cfg.showTrailingWhitespaceColor}
        au BufEnter * match ExtraWhitespace /\s\+$/
        au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
        au InsertLeave * match ExtraWhiteSpace /\s\+$/
      ''}

      ${optionalString cfg.showTabs ''
        highlight Tabs ctermbg=${cfg.showTabsColor} guibg=${cfg.showTabsColor}
        au ColorScheme * highlight Tabs guibg=${cfg.showTabsColor}
        au BufEnter * 2match Tabs /\t\+/
        au InsertEnter * 2match Tabs /\t\+/
        au InsertLeave * 2match Tabs /\t\+/
      ''}

      ${optionalString cfg.trimTrailingWhitespace ''
        au BufWritePre * %s/\s\+$//e
      ''}

      ${optionalString cfg.retabTabs ''
        au BufWritePre * retab
      ''}

      ${optionalString cfg.spell ''
        set spelllang=${cfg.spelllang}
        set spell
      ''}
    '';

    vim.luaConfigRC = ''
      local wk = require("which-key")
      wk.setup { }

      ${optionalString cfg.indentGuide ''
        -- define the highlight groups with only background colors (or leave odd empty to just show the normal background)
        vim.cmd [[highlight IndentOdd guifg=NONE guibg=#222222 gui=nocombine]]
        vim.cmd [[highlight IndentEven guifg=NONE guibg=#333333 gui=nocombine]]
        -- and then use the highlight groups
        vim.g.indent_blankline_char_highlight_list = {"IndentOdd", "IndentEven"}
        vim.g.indent_blankline_space_char_highlight_list = {"IndentOdd", "IndentEven"}

        -- don't show any characters
        vim.g.indent_blankline_char = " "
        vim.g.indent_blankline_space_char = " "

        -- when using background, the trailing indent is not needed / looks wrong
        vim.g.indent_blankline_show_trailing_blankline_indent = false
      ''}
    '';
  };
}
