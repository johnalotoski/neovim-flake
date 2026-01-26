{
  description = "NeoVim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim.url = "github:nix-community/neovim-nightly-overlay";

    # Nix language server
    nil.url = "github:oxalica/nil";

    # Nix linter
    statix.url = "github:nerdypepper/statix";

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

    # Set of preconfigured snippets for different languages
    # TODO: Integrate with LuaSnip
    friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
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

    # TODO: A regexp parser required by LuaSnip for some extended fns
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

    # Icon provider. Part of 'mini.nvim' library
    mini-icons = {
      url = "github:echasnovski/mini.icons";
      flake = false;
    };

    # Library of 40+ independent Lua modules improving overall Neovim (version 0.8 and higher) experience with minimal effort
    mini-nvim = {
      url = "github:echasnovski/mini.nvim";
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
      url = "github:catgoose/nvim-colorizer.lua";
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
    # Required by nvim-telescope
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    # A three-way merge managing plugin
    splice = {
      url = "github:sjl/splice.vim";
      flake = false;
    };

    symbols-outline = {
      url = "github:Vaengir/symbols-outline.nvim";
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
        nixpkgs.lib.subtractLists
        ["nixpkgs" "flake-utils" "neovim" "nil" "statix" "nixpkgs-unstable"]
        (builtins.attrNames inputs);

      # Complete overlay with all plugins and dependencies
      completeOverlay = import ./lib/buildOverlay.nix {
        inherit inputs plugins system;
      };

      pkgs = import nixpkgs {
        inherit system;

        config = {
          # allowBroken = true;
          # allowUnfree = true;
        };

        overlays = [
          completeOverlay
        ];
      };

      lib = import ./lib {
        inherit pkgs plugins inputs;
      };

      inherit (lib) neovimBuilder;
    in rec {
      inherit lib neovimBuilder pkgs;

      apps = {
        nvim = {
          type = "app";
          program = "${packages.neovim}/bin/nvim";
        };
        default = {
          type = "app";
          program = "${packages.neovim}/bin/nvim";
        };
      };

      overlay = self: super: {
        inherit neovimBuilder;
        inherit (packages) neovim;
        inherit
          (pkgs)
          bashls
          cssls
          dockerls
          efm-langserver
          elixirls
          htmlls
          jsonls
          neovim-nightly
          neovimPlugins
          nil
          nvim-treesitter-withAllGrammars
          regols
          statix
          tsserver
          vimls
          yamlls
          ;
      };

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          treefmt
          alejandra

          # Plugin enhancement deps
          fd
          ripgrep
        ];
      };

      packages =
        {
          neovim = neovimBuilder {
            inherit pkgs;
            neovimPackage = neovim.packages.${system}.default;
            config = {};
          };

          default = packages.neovim;

          # Expose neovim-nightly for downstream repos
          neovim-nightly = pkgs.neovim-nightly;
        }
        // pkgs.neovimPlugins;
    });
}
