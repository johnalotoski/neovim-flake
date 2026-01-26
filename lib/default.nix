{
  pkgs,
  inputs,
  plugins,
  self,
  ...
}: let
  neovimBuilderRaw = import ./neovimBuilder.nix;

  # Legacy plugin-only overlay (kept for compatibility)
  buildPluginOverlay = import ./buildPlugin.nix {inherit inputs plugins;};

  # Complete overlay with plugins and all dependencies
  completeOverlay = import ./buildOverlay.nix {
    inherit inputs plugins;
    system = pkgs.stdenv.hostPlatform.system;
  };

  # Wrap neovimBuilder to automatically include the complete overlay
  neovimBuilder = args:
    neovimBuilderRaw (args
      // {
        inherit self;
        pluginOverlay = completeOverlay;
      });
in {
  inherit neovimBuilder buildPluginOverlay completeOverlay;
}
