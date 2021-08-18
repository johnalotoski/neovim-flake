{ pkgs, config, lib, ... }:
with lib;
with builtins;

let cfg = config.vim.editor;
in {
  options.vim.editor = {
    indentGuide = mkEnableOption "Enable indent guides";
    underlineCurrentWord = mkEnableOption "Underline the word under the cursor";
    colourPreview = mkEnableOption "Enable colour previews";
    whichKey = mkEnableOption "Enable Which key";
    floaterm = mkEnableOption "Enable floaterm instead of built in";
    surround = mkEnableOption "Enable vim-surround";
    wilder = mkEnableOption "Enable wilder.nvim";
    abolish = mkEnableOption "Enable vim-abolish";
  };

  config = {
    vim.startPlugins = with pkgs.neovimPlugins;
      (optional cfg.indentGuide indent-blankline-nvim)
      ++ (optional cfg.underlineCurrentWord vim-cursorword)
      ++ (optional cfg.whichKey which-key-nvim)
      ++ (optional cfg.floaterm vim-floaterm)
      ++ (optional cfg.surround vim-surround)
      ++ (optionals cfg.wilder [ wilder-nvim ])
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
