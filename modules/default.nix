{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./core
    ./basic
    ./themes
    ./dashboard
    ./statusline
    ./lsp
    ./fuzzyfind
    ./filetree
    ./git
    ./tabbar
    ./formatting
    ./editor
    ./database
    ./test
  ];
}
