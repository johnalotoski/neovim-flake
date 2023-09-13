{
  description = "NeoVim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";

    neovim = {
      url = "github:neovim/neovim/v0.9.1?dir=contrib";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil.url = "github:oxalica/nil";

    # Vim plugins
    elixir-nvim = {
      url = "github:mhanberg/elixir.nvim";
      flake = false;
    };
    gleam-vim = {
      url = "github:gleam-lang/gleam.vim";
      flake = false;
    };
    zig-vim = {
      url = "github:ziglang/zig.vim";
      flake = false;
    };
    vim-nickel = {
      url = "github:nickel-lang/vim-nickel";
      flake = false;
    };
    gruvbox = {
      url = "github:morhetz/gruvbox";
      flake = false;
    };
    nord-vim = {
      url = "github:arcticicestudio/nord-vim";
      flake = false;
    };
    vim-startify = {
      url = "github:mhinz/vim-startify";
      flake = false;
    };
    lightline-vim = {
      url = "github:itchyny/lightline.vim";
      flake = false;
    };
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    vim-nix = {
      url = "github:LnL7/vim-nix";
      flake = false;
    };
    nvim-dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };
    nvim-telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    telescope-dap = {
      url = "github:nvim-telescope/telescope-dap.nvim";
      flake = false;
    };
    popup-nvim = {
      url = "github:nvim-lua/popup.nvim";
      flake = false;
    };
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:kyazdani42/nvim-web-devicons";
      flake = false;
    };
    nvim-tree-lua = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };
    vimagit = {
      url = "github:jreybert/vimagit";
      flake = false;
    };
    nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
      flake = false;
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvim-treesitter-context = {
      url = "github:romgrk/nvim-treesitter-context";
      flake = false;
    };
    barbar-nvim = {
      url = "github:romgrk/barbar.nvim";
      flake = false;
    };
    editorconfig-vim = {
      url = "github:editorconfig/editorconfig-vim";
      flake = false;
    };
    indent-blankline-nvim = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    nvim-blame-line = {
      url = "github:tveskag/nvim-blame-line";
      flake = false;
    };
    nvim-dap-virtual-text = {
      url = "github:theHamsta/nvim-dap-virtual-text";
      flake = false;
    };
    vim-cursorword = {
      url = "github:itchyny/vim-cursorword";
      flake = false;
    };
    vim-dadbod = {
      url = "github:tpope/vim-dadbod";
      flake = false;
    };
    vim-dadbod-ui = {
      url = "github:kristijanhusak/vim-dadbod-ui";
      flake = false;
    };
    vim-hexokinase = {
      url = "github:RRethy/vim-hexokinase";
      flake = false;
    };
    which-key-nvim = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
    vim-test = {
      url = "github:vim-test/vim-test";
      flake = false;
    };
    vim-floaterm = {
      url = "github:voldikss/vim-floaterm";
      flake = false;
    };
    vim-crystal = {
      url = "github:vim-crystal/vim-crystal";
      flake = false;
    };
    nvim-jqx = {
      url = "github:gennaro-tedesco/nvim-jqx";
      flake = false;
    };
    formatter-nvim = {
      url = "github:mhartington/formatter.nvim";
      flake = false;
    };
    vim-cue = {
      url = "github:jjo/vim-cue";
      flake = false;
    };
    vim-mint = {
      url = "github:IrenejMarc/vim-mint";
      flake = false;
    };
    vim-surround = {
      url = "github:tpope/vim-surround";
      flake = false;
    };
    wilder-nvim = {
      url = "github:gelguy/wilder.nvim";
      flake = false;
    };
    vim-abolish = {
      url = "github:tpope/vim-abolish";
      flake = false;
    };
    vim-go = {
      url = "github:fatih/vim-go";
      flake = false;
    };
    nvim-idris2 = {
      url = "github:ShinKage/nvim-idris2";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-cmdline = {
      url = "github:hrsh7th/cmp-cmdline";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    LuaSnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    cmp_luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    lsp_signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };
    splice = {
      url = "github:sjl/splice.vim";
      flake = false;
    };
    vim-slim = {
      url = "github:slim-template/vim-slim";
      flake = false;
    };
    vim-just = {
      url = "github:NoahTheDuke/vim-just";
      flake = false;
    };
    no-neck-pain = {
      url = "github:shortcuts/no-neck-pain.nvim";
      flake = false;
    };
    copilot-vim = {
      url = "github:github/copilot.vim";
      flake = false;
    };
    nvim-nu = {
      url = "github:LhKipp/nvim-nu";
      flake = false;
    };
    null-ls-nvim = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
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
        # config = {allowUnfree = true;};
        overlays = [
          pluginOverlay
          (final: prev: {
            statix = inputs.statix.defaultPackage.${system};
            inherit (inputs.nil.packages.${system}) nil;
            tsserver = prev.nodePackages.typescript-language-server;
            vimls = prev.nodePackages.vim-language-server;
            yamlls = prev.nodePackages.yaml-language-server;
            dockerls = prev.nodePackages.dockerfile-language-server-nodejs;
            cssls = prev.nodePackages.vscode-css-languageserver-bin;
            htmlls = prev.nodePackages.vscode-html-languageserver-bin;
            jsonls = prev.nodePackages.vscode-json-languageserver-bin;
            bashls = prev.nodePackages.bash-language-server;

            neovim-nightly =
              neovim.defaultPackage.${system}.overrideAttrs
              (_: {
                patches = [
                  "${inputs.nixpkgs}/pkgs/applications/editors/neovim/system_rplugin_manifest.patch"
                ];
              });

            efm-langserver = prev.buildGoModule rec {
              pname = "efm-langserver";
              version = "0.0.36";
              vendorSha256 = "sha256-tca+1SRrFyvU8ttHmfMFiGXd1A8rQSEWm1Mc2qp0EfI=";
              src = prev.fetchFromGitHub {
                owner = "mattn";
                repo = pname;
                rev = "v${version}";
                sha256 = "sha256-X2z49KmJiKh1QtcDBZcqNiMhq5deVamS47w6gyVq7Oo=";
              };
            };

            regols = prev.buildGoModule rec {
              pname = "regols";
              version = "0.1.0";
              vendorSha256 = "sha256-iyY8MycN/G6jj5hqb1ewyEkIMbTMJdILqHczxAYlxng=";
              src = prev.fetchFromGitHub {
                owner = "kitagry";
                repo = pname;
                rev = "v${version}";
                sha256 = "sha256-2MTetTWHJAiSWPcEFJ/p0xptAWDKNXwTq68RywUO+Ls=";
              };
            };

            elixirls = prev.fetchzip {
              url = "https://github.com/elixir-lsp/elixir-ls/releases/download/v0.11.0/elixir-ls.zip";
              hash = "sha256-Q1c+HMK9mhIX4bK9OddfckiR3gpxu9bITI5ED8FCHmI=";
              stripRoot = false;
            };
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
        nativeBuildInputs = [pkgs.treefmt pkgs.alejandra];
      };

      packages.neovim = neovimBuilder {
        config.vim = {
          dashboard.startify.customHeader = ["Welcome to NeoVim"];
          dashboard.startify.enable = true;
          database.enable = true;
          disableArrows = false;
          virtualedit = "all";

          editor = {
            surround = true;
            colourPreview = true;
            whichKey = true;
            floaterm = true;
            wilder = true;
            abolish = true;
          };

          filetree.nvimTreeLua = {enable = true;};
          formatting.editorConfig.enable = true;
          fuzzyfind.telescope.enable = true;
          statusline.lightline.enable = true;
          tabbar.barbar.enable = true;
          test.enable = true;
          theme.gruvbox.enable = true;
          viAlias = false;
          vimAlias = false;
          lineNumberMode = "number";
          showTrailingWhitespace = true;
          trimTrailingWhitespace = true;

          git = {
            enable = true;
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
            gleam = true;
            go = true;
            haskell = true;
            html = true;
            idris2 = true;
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
