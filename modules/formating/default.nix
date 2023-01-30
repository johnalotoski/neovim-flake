{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./editorconfig.nix
    ./format.nix
  ];
}
