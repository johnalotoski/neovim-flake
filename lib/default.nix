{
  pkgs,
  inputs,
  plugins,
  ...
}: {
  inherit (pkgs.lib);
  neovimBuilder = import ./neovimBuilder.nix;
  buildPluginOverlay = import ./buildPlugin.nix {inherit inputs plugins;};
}
