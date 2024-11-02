{
  description = "NeoVim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim.url = "github:nix-community/neovim-nightly-overlay";

    # Nix language server
    nil.url = "github:oxalica/nil";

    # -- Vim plugins
    # Tab bar at the top of the editor
    barbar-nvim = {
      url = "github:romgrk/barbar.nvim";
      flake = false;
    };

    # nvim-cmp source for buffer words
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };

    # nvim-cmp source for vim's cmdline
    cmp-cmdline = {
      url = "github:hrsh7th/cmp-cmdline";
      flake = false;
    };

    # luasnip completion source for nvim-cmp
    cmp_luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };

    # nvim-cmp source for neovim builtin LSP client
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };

    # nvim-cmp source for path
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };

    # Neovim plugin for GitHub Copilot
    copilot-vim = {
      url = "github:github/copilot.vim";
      flake = false;
    };

    # A language support plugin for Elixir
    elixir-nvim = {
      url = "github:mhanberg/elixir.nvim/v0.16.1";
      flake = false;
    };

    # An lsp status indicator for Neovim
    fidget-nvim = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };

    # A format runner for Neovim
    formatter-nvim = {
      url = "github:mhartington/formatter.nvim";
      flake = false;
    };

    # Git integration for buffers
    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    # Retro groove color scheme for Vim
    gruvbox = {
      url = "github:morhetz/gruvbox";
      flake = false;
    };

    # A plugin for adding indent guides for Neovim
    indent-blankline-nvim = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };

    # A plugin for advanced haskell lsp support
    haskell-tools = {
      url = "github:mrcjkb/haskell-tools.nvim";
      flake = false;
    };

    # TODO: A regexp parser reguired by LuaSnip for some extended fns
    # Ref: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#transformations
    # jsregexp = {
    #   url = "github:kmarius/jsregexp";
    #   flake = false;
    # };

    # A light and configurable statusline/tabline plugin for Vim
    lightline-vim = {
      url = "github:itchyny/lightline.vim";
      flake = false;
    };

    # A plugin to add LSP signatures
    lsp_signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };

    # A snippet Engine for Neovim written in Lua
    LuaSnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };

    # A plugin to center the currently focused buffer to the middle of the screen
    no-neck-pain = {
      url = "github:shortcuts/no-neck-pain.nvim";
      flake = false;
    };

    # An arctic, north-bluish clean and elegant Vim theme
    nord-vim = {
      url = "github:arcticicestudio/nord-vim";
      flake = false;
    };

    # A language server to inject LSP diagnostics, code actions, and more via Lua
    # TODO: migrate non-lsp actions to lsp
    # Example: https://nullvoxpopuli.com/2023-03-13-null-ls
    null-ls-nvim = {
      url = "github:nvimtools/none-ls.nvim";
      flake = false;
    };

    # A git blame line viewing plugin
    nvim-blame-line = {
      url = "github:tveskag/nvim-blame-line";
      flake = false;
    };

    # A Lua completion plugin
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };

    # A high performance Neovim colorizer
    nvim-colorizer-lua = {
      url = "github:norcalli/nvim-colorizer.lua";
      flake = false;
    };

    # Debug Adapter Protocol client implementation for Neovim
    nvim-dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };

    # A debug plugin to add virtual-text to nvim-dap
    nvim-dap-virtual-text = {
      url = "github:theHamsta/nvim-dap-virtual-text";
      flake = false;
    };

    # A json preview and browsing plugin
    nvim-jqx = {
      url = "github:gennaro-tedesco/nvim-jqx";
      flake = false;
    };

    # A VSCode 💡 for neovim's built-in LSP.
    nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
      flake = false;
    };

    # Quickstart configs for Nvim LSP
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    # A language support plugin for Nu
    nvim-nu = {
      url = "github:LhKipp/nvim-nu";
      flake = false;
    };

    # A find, filter, preview, pick fuzzy finder
    nvim-telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    # A file explorer tree plugin
    nvim-tree-lua = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };

    # An icons plugin, with light and dark variants
    nvim-web-devicons = {
      url = "github:kyazdani42/nvim-web-devicons";
      flake = false;
    };

    # A Lua functions library for neovim
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    # A three-way merge managing plugin
    splice = {
      url = "github:sjl/splice.vim";
      flake = false;
    };

    # A debug to telescope integration plugin
    telescope-dap = {
      url = "github:nvim-telescope/telescope-dap.nvim";
      flake = false;
    };

    # An abbreviation, coercion and substitution plugin
    vim-abolish = {
      url = "github:tpope/vim-abolish";
      flake = false;
    };

    # A git integration plugin
    vimagit = {
      url = "github:jreybert/vimagit";
      flake = false;
    };

    # A feature rich vim plugin for Crystal
    vim-crystal = {
      url = "github:vim-crystal/vim-crystal";
      flake = false;
    };

    # A syntax highlighter for CUE
    vim-cue = {
      url = "github:jjo/vim-cue";
      flake = false;
    };

    # A same-word underlining plugin
    vim-cursorword = {
      url = "github:itchyny/vim-cursorword";
      flake = false;
    };

    # A database interaction UI plugin
    vim-dadbod-ui = {
      url = "github:kristijanhusak/vim-dadbod-ui";
      flake = false;
    };

    # A database interaction plugin
    vim-dadbod = {
      url = "github:tpope/vim-dadbod";
      flake = false;
    };

    # A floating terminal implementation
    vim-floaterm = {
      url = "github:voldikss/vim-floaterm";
      flake = false;
    };

    # A feature rich vim plugin for go
    vim-go = {
      url = "github:fatih/vim-go";
      flake = false;
    };

    # A syntax highlighter for Just
    vim-just = {
      url = "github:NoahTheDuke/vim-just";
      flake = false;
    };

    # A syntax highlighter, file detection and indenter for Mint
    vim-mint = {
      url = "github:IrenejMarc/vim-mint";
      flake = false;
    };

    # A syntax highlighter, file detection and indenter for Nickel
    vim-nickel = {
      url = "github:nickel-lang/vim-nickel";
      flake = false;
    };

    # A syntax highlighter, file detection and indenter for Nix
    vim-nix = {
      url = "github:LnL7/vim-nix";
      flake = false;
    };

    # A code formatter for Haskell
    vim-ormolu = {
      url = "github:sdiehl/vim-ormolu";
      flake = false;
    };

    # A syntax highlighter for slim, a rails templating DSL
    vim-slim = {
      url = "github:slim-template/vim-slim";
      flake = false;
    };

    # A start page for neovim with suggested actions
    vim-startify = {
      url = "github:mhinz/vim-startify";
      flake = false;
    };

    # A set of hotkeys for actions surrounding text blobs
    vim-surround = {
      url = "github:tpope/vim-surround";
      flake = false;
    };

    # A test suit wrapper for various languages
    vim-test = {
      url = "github:vim-test/vim-test";
      flake = false;
    };

    # A pop up menu helper that to display keybindings, ex: leader key
    which-key-nvim = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    # A pop up helper for :CMD and /SEARCH in lower left
    wilder-nvim = {
      url = "github:gelguy/wilder.nvim";
      flake = false;
    };

    # A code formatter for zig
    zig-vim = {
      url = "github:ziglang/zig.vim";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    neovim,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      plugins =
        pkgs.lib.subtractLists
        ["nixpkgs" "flake-utils" "neovim" "nil"]
        (builtins.attrNames inputs);

      pluginOverlay = lib.buildPluginOverlay;

      pkgs = import nixpkgs {
        inherit system;

        config = {
          # allowBroken = true;
          # allowUnfree = true;
        };

        overlays = [
          pluginOverlay
          (final: prev: {
            inherit (inputs.nil.packages.${system}) nil;

            bashls = prev.nodePackages.bash-language-server;
            cssls = prev.nodePackages.vscode-css-languageserver-bin;
            dockerls = prev.nodePackages.dockerfile-language-server-nodejs;

            efm-langserver = prev.buildGoModule rec {
              pname = "efm-langserver";
              version = "0.0.53";
              vendorHash = "sha256-0YkUak6+dpxvXn6nVVn33xrTEthWqnC9MhMLm/yjFMA=";
              src = prev.fetchFromGitHub {
                owner = "mattn";
                repo = pname;
                rev = "v${version}";
                sha256 = "sha256-Csm+2C9hP+dTXliADUquAb1nC+8f5j1rJ+66cqWDrCk=";
              };
            };

            # Elixir language server
            elixirls = prev.fetchzip {
              url = "https://github.com/elixir-lsp/elixir-ls/releases/download/v0.24.1/elixir-ls-v0.24.1.zip";
              hash = "sha256-18guwWL+oq3iXTxjqmNO0Bst29nbNH9xwdsuu8oUFz4=";
              stripRoot = false;
            };

            htmlls = prev.nodePackages.vscode-html-languageserver-bin;
            jsonls = prev.nodePackages.vscode-json-languageserver-bin;

            neovim-nightly = neovim.packages.${system}.default;

            nvim-treesitter-withAllGrammars = inputs.nixpkgs-unstable.legacyPackages.${system}.vimPlugins.nvim-treesitter.withAllGrammars;

            # OPA Rego language server
            regols = prev.buildGoModule rec {
              pname = "regols";
              version = "0.2.4";
              vendorHash = "sha256-yJYWVQq6pbLPdmK4BVse6moMkurlmt6TBd6/vYM1xcU=";
              src = prev.fetchFromGitHub {
                owner = "kitagry";
                repo = pname;
                rev = "v${version}";
                sha256 = "sha256-1L9ehqTMN9KHlvE7FBccVAXA7f3NNsLXJaTkOChT8Xo=";
              };
            };

            statix = inputs.statix.defaultPackage.${system};
            tsserver = prev.nodePackages.typescript-language-server;
            vimls = prev.nodePackages.vim-language-server;
            yamlls = prev.nodePackages.yaml-language-server;
          })
        ];
      };

      lib = import ./lib {
        inherit pkgs plugins inputs;
      };

      inherit (lib) neovimBuilder;
    in rec {
      inherit neovimBuilder pkgs;

      apps = {
        nvim = {
          type = "app";
          program = "${defaultPackage}/bin/nvim";
        };
      };

      defaultApp = apps.nvim;

      defaultPackage = packages.neovim;

      overlay = self: super: {
        inherit neovimBuilder;
        inherit (packages) neovim;
        inherit (pkgs) neovimPlugins;
      };

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          treefmt
          alejandra
        ];
      };

      packages.neovim = neovimBuilder {
        config.vim = {
          dashboard.startify.customHeader = ["Welcome to NeoVim"];
          dashboard.startify.enable = true;
          database.enable = true;
          disableArrows = false;
          virtualedit = "all";

          editor = {
            abolish = true;
            colorPreview = true;
            floaterm = false;

            # Might be nice to have starting from toggled off state
            indentGuide = false;

            retabTabs = true;
            showTabs = true;
            showTrailingWhitespace = true;
            spell = true;
            surround = true;
            trimTrailingWhitespace = true;
            underlineCurrentWord = true;
            whichKey = true;
            wilder = true;
          };

          filetree.nvimTreeLua = {enable = true;};
          fuzzyfind.telescope.enable = true;
          lineNumberMode = "number";
          statusline.lightline.enable = true;
          tabbar.barbar.enable = true;
          test.enable = true;
          theme.gruvbox.enable = true;
          viAlias = true;
          vimAlias = true;

          git = {
            enable = true;

            # Appears to no longer work
            blameLine = false;
          };

          lsp = {
            enable = true;

            bash = true;
            clang = true;
            cmake = true;
            crystal = true;
            css = true;
            docker = true;
            elixir = true;
            fidget = true;
            gleam = true;
            go = true;
            haskellLspConfig = false;
            haskellTools = true;
            html = true;
            json = true;
            lightbulb = true;
            mint = true;
            nickel = true;
            nix = true;
            nu = true;
            python = true;
            rego = true;
            ruby = true;
            rust = true;
            shellcheck = true;
            terraform = true;
            tex = true;
            typescript = true;
            variableDebugPreviews = true;
            vimscript = true;
            yaml = true;
            zig = true;
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
            "<silent> <Space>bb" = "<Cmd>BufferOrderByBufferNumber<CR>";
            "<silent> <Space>bd" = "<Cmd>BufferOrderByDirectory<CR>";
            "<silent> <Space>bl" = "<Cmd>BufferOrderByLanguage<CR>";
            "<silent> <Space>bw" = "<Cmd>BufferOrderByWindowNumber<CR>";
          };
        };
      };
    });
}
