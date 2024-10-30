{
  inputs,
  plugins,
  ...
}: final: prev: let
  mapPlugin = name: {
    inherit name;
    value = prev.vimUtils.buildVimPlugin {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
    };
  };
in {
  neovimPlugins = builtins.listToAttrs (map mapPlugin plugins);
}
