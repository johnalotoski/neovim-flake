{
  pkgs,
  lib ? pkgs.lib,
  ...
}: {config}: let
  vimOptions = lib.evalModules {
    modules = [{imports = [../modules];} config];

    specialArgs = {inherit pkgs;};
  };

  vim = vimOptions.config.vim;
in
  pkgs.wrapNeovim pkgs.neovim-nightly {
    viAlias = config.vim.viAlias;
    vimAlias = config.vim.vimAlias;
    configure = {
      customRC = vim.configRC;

      packages.myVimPackage = {
        start = vim.startPlugins;
        opt = vim.optPlugins;
      };
    };
  }
