{
  inputs,
  plugins,
  system,
  ...
}: final: prev: let
  # Build all vim plugins from inputs
  mapPlugin = name: {
    inherit name;
    value = prev.vimUtils.buildVimPlugin {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
      doCheck = false;
    };
  };

  # Default plugin builds (can be overridden by prev)
  defaultNeovimPlugins = builtins.listToAttrs (map mapPlugin plugins);

  # Default efm-langserver build
  defaultEfmLangserver = prev.buildGoModule rec {
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

  # Default elixirls build
  defaultElixirls = prev.fetchzip {
    url = "https://github.com/elixir-lsp/elixir-ls/releases/download/v0.24.1/elixir-ls-v0.24.1.zip";
    hash = "sha256-68guwWL+oq3iXTxjqmNO0Bst29nbNH9xwdsuu8oUFz4=";
    stripRoot = false;
  };

  # Default regols build
  defaultRegols = prev.buildGoModule rec {
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
in
  {
    # Respect user's neovimPlugins if provided, otherwise use defaults
    neovimPlugins = prev.neovimPlugins or defaultNeovimPlugins;

    # Respect user's packages if already defined, otherwise use our defaults
    nil = prev.nil or inputs.nil.packages.${system}.default;
    bashls = prev.bashls or prev.nodePackages.bash-language-server;
    cssls = prev.cssls or prev.vscode-langservers-extracted;
    dockerls = prev.dockerls or prev.dockerfile-language-server;
    efm-langserver = prev.efm-langserver or defaultEfmLangserver;
    elixirls = prev.elixirls or defaultElixirls;
    htmlls = prev.htmlls or prev.vscode-langservers-extracted;
    jsonls = prev.jsonls or prev.vscode-langservers-extracted;
    neovim-nightly = prev.neovim-nightly or inputs.neovim.packages.${system}.default;
    nvim-treesitter-withAllGrammars =
      prev.nvim-treesitter-withAllGrammars
      or inputs.nixpkgs-unstable.legacyPackages.${system}.vimPlugins.nvim-treesitter.withAllGrammars;
    regols = prev.regols or defaultRegols;
    statix = prev.statix or inputs.statix.packages.${system}.default;
    tsserver = prev.tsserver or prev.nodePackages.typescript-language-server;
    vimls = prev.vimls or prev.nodePackages.vim-language-server;
    yamlls = prev.yamlls or prev.nodePackages.yaml-language-server;
  }
  // (builtins.mapAttrs (name: plugin: prev.${name} or plugin) defaultNeovimPlugins)
