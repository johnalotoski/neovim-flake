{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim;
in {
  options.vim = {
    colourTerm = mkOption {
      default = true;
      description = "Set terminal up for 256 colours";
      type = types.bool;
    };

    disableArrows = mkOption {
      default = false;
      description = "Set to prevent arrow keys from moving cursor";
      type = types.bool;
    };

    hideSearchHighlight = mkOption {
      default = false;
      description = "Hide search highlight so it doesn't stay highlighted";
      type = types.bool;
    };

    scrollOffset = mkOption {
      default = 8;
      description = "Start scrolling this number of lines from the top or bottom of the page.";
      type = types.int;
    };

    wordWrap = mkOption {
      default = false;
      description = "Enable word wrapping.";
      type = types.bool;
    };

    syntaxHighlighting = mkOption {
      default = true;
      description = "Enable syntax highlighting";
      type = types.bool;
    };

    mapLeaderSpace = mkOption {
      default = true;
      description = "Map the space key to leader key";
      type = types.bool;
    };

    useSystemClipboard = mkOption {
      default = true;
      description = "Make use of the clipboard for default yank and paste operations. Don't use * and +";
      type = types.bool;
    };

    mouseSupport = mkOption {
      default = "a";
      description = "Set modes for mouse support. a - all, n - normal, v - visual, i - insert, c - command";
      type = types.str;
    };

    lineNumberMode = mkOption {
      default = "relNumber";
      description = "How line numbers are displayed. none, relative, number, relNumber";
      type = with types; enum ["relative" "number" "relNumber" "none" "auto"];
    };

    preventJunkFiles = mkOption {
      default = true;
      description = "Prevent swapfile, backupfile from being created";
      type = types.bool;
    };

    tabWidth = mkOption {
      default = 2;
      description = "Set the width of tabs to 2";
      type = types.int;
    };

    autoIndent = mkOption {
      default = true;
      description = "Enable auto indent";
      type = types.bool;
    };

    cmdHeight = mkOption {
      default = 2;
      description = "Hight of the command pane";
      type = types.int;
    };

    updateTime = mkOption {
      default = 300;
      description = "The number of milliseconds till Cursor Hold event is fired";
      type = types.int;
    };

    showSignColumn = mkOption {
      default = true;
      description = "Show the sign column";
      type = types.bool;
    };

    bell = mkOption {
      default = "none";
      description = "Set how bells are handled. Options: on, visual or none";
      type = types.enum ["none" "visual" "on"];
    };

    mapTimeout = mkOption {
      default = 500;
      description = "Timeout in ms that neovim will wait for mapped action to complete";
      type = types.int;
    };

    splitBelow = mkOption {
      default = true;
      description = "New splits will open below instead of on top";
      type = types.bool;
    };

    splitRight = mkOption {
      default = true;
      description = "New splits will open to the right";
      type = types.bool;
    };

    virtualedit = mkOption {
      default = "none";
      description = ''
        Virtual editing means that the cursor can be positioned where there is
        no actual character.  This can be halfway into a tab or beyond the end
        of the line. Useful for selecting a rectangle in Visual mode and
        editing a table.
      '';
      type = types.enum ["block" "insert" "all" "onemore" "none"];
    };
  };

  config = {
    vim.nmap = optionalAttrs cfg.disableArrows {
      "<up>" = "<nop>";
      "<down>" = "<nop>";
      "<left>" = "<nop>";
      "<right>" = "<nop>";
    };

    vim.imap = optionalAttrs cfg.disableArrows {
      "<up>" = "<nop>";
      "<down>" = "<nop>";
      "<left>" = "<nop>";
      "<right>" = "<nop>";
    };

    vim.configRC = ''
      "Settings that are set for everything
      set encoding=utf-8
      set mouse=${cfg.mouseSupport}
      set tabstop=${toString cfg.tabWidth}
      set shiftwidth=${toString cfg.tabWidth}
      set softtabstop=${toString cfg.tabWidth}
      set expandtab
      set cmdheight=${toString cfg.cmdHeight}
      set updatetime=${toString cfg.updateTime}
      set shortmess+=c
      set tm=${toString cfg.mapTimeout}
      set hidden
      set autoread
      set wildmenu
      set backup
      set undofile
      set undolevels=1000
      set ignorecase
      set smartcase
      ${optionalString cfg.splitBelow "set splitbelow"}
      ${optionalString cfg.splitRight "set splitright"}
      ${optionalString cfg.showSignColumn "set signcolumn=yes"}
      ${optionalString cfg.autoIndent "set autoindent"}
      ${optionalString cfg.useSystemClipboard "set clipboard+=unnamedplus"}
      ${optionalString cfg.syntaxHighlighting "syntax on"}
      ${optionalString (!cfg.wordWrap) "set nowrap"}
      ${optionalString cfg.preventJunkFiles ''
        set noswapfile
        set nobackup
        set nowritebackup
      ''}
      ${optionalString cfg.mapLeaderSpace ''
        let mapleader=" "
        let maplocalleader=" "
      ''}
      ${optionalString cfg.hideSearchHighlight ''
        set nohlsearch
        set incsearch
      ''}
      ${optionalString cfg.colourTerm ''
        set termguicolors
        set t_Co=256
      ''}
      ${{
          visual = "set noerrorbells";
          on = "set novisualbell";
          none = ''
            set noerrorbells
            set novisualbell
          '';
        }
        .${cfg.bell}
        or ""}
      ${{
          relative = "set relativenumber";
          number = "set number";
          relNumber = "set number relativenumber";
          auto = ''
            set number
            augroup numbertoggle
              autocmd!
              autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
              autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
            augroup END
          '';
        }
        .${cfg.lineNumberMode}
        or ""}
      set virtualedit=${cfg.virtualedit}
    '';
  };
}
