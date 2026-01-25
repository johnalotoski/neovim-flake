{
  pkgs,
  lib ? pkgs.lib,
  neovimPackage ? pkgs.neovim,
}: {config}: let
  vimOptions = lib.evalModules {
    modules = [
      {
        imports = [
          ../modules
          (import ./default-config.nix lib)
        ];
      }
      config
    ];

    specialArgs = {inherit pkgs;};
  };

  vim = vimOptions.config.vim;
in
  pkgs.wrapNeovim neovimPackage {
    viAlias = vim.viAlias;
    vimAlias = vim.vimAlias;
    configure = {
      customRC = vim.configRC;

      packages.myVimPackage = {
        start = vim.startPlugins;
        opt = vim.optPlugins;
      };
    };
  }
