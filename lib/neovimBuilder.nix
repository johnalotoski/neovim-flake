{
  self,
  pkgs,
  lib ? pkgs.lib,
  neovimPackage ? pkgs.neovim-nightly or self.packages.${pkgs.stdenv.hostPlatform.system}.neovim-nightly,
  config ? {},
  includeDefaults ? true,
  extraSpecialArgs ? {},
  pluginOverlay ? (final: prev: {}),
  extraOverlay ? (final: prev: {}),
}: let
  # Validate config is an attrset
  _ = assert lib.assertMsg (lib.isAttrs config) "config must be an attribute set"; true;

  # Apply overlays:
  # 1. First apply the plugin overlay (provides neovimPlugins and dependencies)
  # 2. Then apply user's extra overlay (allows overriding our defaults)
  pkgsWithPlugins = (pkgs.extend pluginOverlay).extend extraOverlay;

  vimOptions = lib.evalModules {
    modules = [
      {
        imports =
          [
            ../modules
          ]
          ++ lib.optional includeDefaults (import ./default-config.nix lib);
      }
      config
    ];

    specialArgs = {pkgs = pkgsWithPlugins;} // extraSpecialArgs;
  };

  vim = vimOptions.config.vim;
in
  pkgsWithPlugins.wrapNeovim neovimPackage {
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
