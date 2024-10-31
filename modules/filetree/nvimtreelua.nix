{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.filetree.nvimTreeLua;
  indent = n: builtins.concatStringsSep "" (builtins.genList (a: " ") n);
  nl = "\n";

  # Totally naive translation of Nix expressions to Lua.
  toLua = level: o: let
    type = builtins.typeOf o;
  in
    if type == "bool"
    then lib.boolToString o
    else if type == "string"
    then ''"${o}"''
    else if type == "list"
    then "{" + (lib.concatStringsSep ", " (map toLua o)) + "}"
    else if type == "int"
    then toString o
    else if type == "null"
    then "nil"
    else if type == "set"
    then ''
      {
      ${lib.concatStringsSep ",${nl}"
        (lib.mapAttrsToList (k: v: "${indent level}${k} = ${toLua (level + 2) v}")
          o)}
      ${indent (level - 2)}}''
    else throw "Cannot translate unknown type '${type}' to Lua";

  optionsToLua = toLua 2;
in {
  options.vim.filetree.nvimTreeLua = {
    enable = mkEnableOption "Enable nvim-tree-lua";

    devIcons = mkOption {
      default = true;
      description = "Install devicons to display next to files";
      type = types.bool;
    };

    treeSide = mkOption {
      default = "left";
      description = "Side the tree will appear on left or right";
      type = types.enum ["left" "right"];
    };

    treeWidth = mkOption {
      default = 30;
      description = "Width of the tree in charecters";
      type = types.int;
    };

    hideFiles = mkOption {
      default = [".git" "node_modules" ".cache"];
      description = "Files to hide in the file view by default";
      type = with types; listOf str;
    };

    hideIgnoredGitFiles = mkOption {
      default = false;
      description = "Hide files ignored by git";
      type = types.bool;
    };

    openOnDirectoryStart = mkOption {
      default = true;
      description = "Open when vim is started on a directory";
      type = types.bool;
    };

    closeOnLastWindow = mkOption {
      default = true;
      description = "Close when tree is last window open";
      type = types.bool;
    };

    ignoreFileTypes = mkOption {
      default = ["startify"];
      description = "Ignore file types";
      type = with types; listOf str;
    };

    closeOnFileOpen = mkOption {
      default = false;
      description = "Close the tree when a file is opened";
      type = types.bool;
    };

    followBufferFile = mkOption {
      default = true;
      description = "Follow file that is in current buffer on tree";
      type = types.bool;
    };

    indentMarkers = mkOption {
      default = true;
      description = "Show indent markers";
      type = types.bool;
    };

    hideDotFiles = mkOption {
      default = false;
      description = "Hide dotfiles";
      type = types.bool;
    };

    openTreeOnNewTab = mkOption {
      default = false;
      description = "Opens the tree view when opening a new tab";
      type = types.bool;
    };

    disableNetRW = mkOption {
      default = true;
      description = "Disables netrw and replaces it with tree";
      type = types.bool;
    };

    trailingSlash = mkOption {
      default = true;
      description = "Add a trailing slash to all folders";
      type = types.bool;
    };

    groupEmptyFolders = mkOption {
      default = true;
      description = "compat empty folders trees into a single item";
      type = types.bool;
    };

    lspDiagnostics = mkOption {
      default = true;
      description = "Shows lsp diagnostics in the tree";
      type = types.bool;
    };

    # TODO: Some of these options are deprecated and likely some new options are missing; update these
    setup = mkOption {
      description = "all options that are configured in the setup hook";
      default = {};
      type = types.submodule {
        options = {
          disable_netrw = mkOption {
            default = true;
            description = "completely disable netrw";
            type = types.bool;
          };

          hijack_netrw = mkOption {
            default = true;
            description = "hijack netrw windows (overriden if disable_netrw is `true`)";
            type = types.bool;
          };

          # open_on_setup = mkOption {
          #   default = false;
          #   description = "will automatically open the tree when running setup if current buffer is a directory, is empty or is unnamed.";
          #   type = types.bool;
          # };

          # ignore_ft_on_setup = mkOption {
          #   description = "list of filetypes that will make open_on_setup not open. You can use this option if you don't want the tree to open in some scenarios (eg using vim startify).";
          #   type = types.listOf types.str;
          #   default = [];
          # };

          open_on_tab = mkOption {
            description = "opens the tree automatically when switching tabpage or opening a new tabpage if the tree was previously open.";
            type = types.bool;
            default = false;
          };

          hijack_directories = mkOption {
            description = "hijacks new directory buffers when they are opened (`:e dir`).";
            default = {};
            type = types.submodule {
              options = {
                enable = mkOption {
                  description = "enable the feature. Disable this option if you use vim-dirvish.";
                  type = types.bool;
                  default = true;
                };

                auto_open = mkOption {
                  description = "opens the tree if the tree was previously closed.";
                  type = types.bool;
                  default = true;
                };
              };
            };
          };

          hijack_cursor = mkOption {
            description = "keeps the cursor on the first letter of the filename when moving in the tree.";
            type = types.bool;
            default = false;
          };

          update_cwd = mkOption {
            description = "changes the tree root directory on `DirChanged` and refreshes the tree.";
            type = types.bool;
            default = false;
          };

          update_focused_file = mkOption {
            description = "update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file";
            default = {};
            type = types.submodule {
              options = {
                enable = mkOption {
                  description = "enable this feature.";
                  type = types.bool;
                  default = false;
                };

                update_cwd = mkOption {
                  description = ''
                    update the root directory of the tree to the one
                        of the folder containing the file if the file is not under the current root
                        directory. Only relevant when |update_focused_file.enable| is `true`'';
                  type = types.bool;
                  default = false;
                };

                ignore_list = mkOption {
                  description = "list of buffer names and filetypes that will not update the root dir of the tree if the file isn't found under the current root directory. Only relevant when |update_focused_file.update_cwd| is `true` and |update_focused_file.enable| is `true`.";
                  type = types.listOf types.str;
                  default = [];
                };
              };
            };
          };

          system_open = mkOption {
            description = "configuration options for the system open command";
            default = {};
            type = types.submodule {
              options = {
                cmd = mkOption {
                  description = "the command to run, leaving nil should work but useful if you want to override the default command with another one.";
                  type = types.nullOr types.str;
                  default = null;
                };

                args = mkOption {
                  description = "the command arguments as a list";
                  type = types.listOf types.str;
                  default = [];
                };
              };
            };
          };

          diagnostics = mkOption {
            description = ''
              show lsp diagnostics in the signcolumn
              `NOTE`: it will use the default diagnostic color groups to highlight the signs.
              If you wish to customize, you can override these groups:
              - `NvimTreeLspDiagnosticsError`
              - `NvimTreeLspDiagnosticsWarning`
              - `NvimTreeLspDiagnosticsInformation`
              - `NvimTreeLspDiagnosticsHint`
            '';
            default = {};
            type = types.submodule {
              options = {
                enable = mkOption {
                  description = "enable/disable the feature";
                  type = types.bool;
                  default = false;
                };

                icons = mkOption {
                  description = "icons for diagnostic severity";
                  type = types.attrsOf types.str;
                  default = {
                    hint = "";
                    info = "";
                    warning = "";
                    error = "";
                  };
                };
              };
            };
          };

          git = mkOption {
            description = ''
              git integration with icons and colors

              You will still need to configure `g:nvim_tree_show_icons.git` or
              `g:nvim_tree_git_hl` to be able to see things in the tree. This will be
              changed in the future versions.

              The configurable timeout will kill the current process and so disable the
              git integration for the project that takes too long.
              The git integration is blocking, so if your timeout is too long (like not in
              milliseconds but a few seconds), it will not render anything until the git
              process returned the data.
            '';
            default = {};

            type = types.submodule {
              options = {
                enable = mkOption {
                  description = "enable / disable the feature";
                  type = types.bool;
                  default = true;
                };

                ignore = mkOption {
                  description = ''
                    ignore files based on `.gitignore`.
                    will add `ignored=matching` to the integration when `true`. Otherwise will
                    add `ignored=no` to the integration which can lead to better performance.
                  '';
                  type = types.bool;
                  default = true;
                };

                timeout = mkOption {
                  description = "kills the git process after some time (in ms) if it takes too long";
                  type = types.ints.positive;
                  default = 400;
                };
              };
            };
          };

          view = mkOption {
            description = "window / buffer setup";
            default = {};
            type = types.submodule {
              options = {
                # hide_root_folder = mkOption {
                #   description = "hide the path of the current working directory on top of the tree";
                #   type = types.bool;
                #   default = false;
                # };

                width = mkOption {
                  description = "width of the window, can be either a `%` string or a number representing columns. Only works with |view.side| `left` or `right`";
                  type = types.oneOf [types.str types.ints.positive];
                  default = 30;
                };

                # height = mkOption {
                #   description = "height of the window, can be either a `%` string or a number representing rows. Only works with |view.side| `top` or `bottom`";
                #   type = types.oneOf [types.str types.ints.positive];
                #   default = 30;
                # };

                side = mkOption {
                  description = "side of the tree, can be one of 'left' | 'right' | 'bottom' | 'top' Note that bottom/top are not working correctly yet.";
                  type = types.enum ["left" "right" "bottom" "top"];
                  default = "left";
                };

                number = mkOption {
                  description = "print the line number in front of each line.";
                  type = types.bool;
                  default = false;
                };

                relativenumber = mkOption {
                  description = "show the line number relative to the line with the cursor in front of each line. If the option `view.number` is also `true`, the number on the cursor line will be the line number instead of `0`.";
                  type = types.bool;
                  default = false;
                };

                # mappings = mkOption {
                #   description = "configuration options for keymaps";
                #   default = {};
                #   type = types.submodule {
                #     options = {
                #       custom_only = mkOption {
                #         description = "will use only the provided user mappings and not the default otherwise, extends the default mappings with the provided user mappings";
                #         type = types.bool;
                #         default = false;
                #       };

                #       list = mkOption {
                #         description = "a list of keymaps that will extend or override the default keymaps";
                #         type = types.attrsOf types.str;
                #         default = {};
                #       };
                #     };
                #   };
                # };
              };
            };
          };

          filters = mkOption {
            description = "filtering options";
            default = {};
            type = types.submodule {
              options = {
                dotfiles = mkOption {
                  description = "do not show `dotfiles` (files starting with a `.`)";
                  type = types.bool;
                  default = false;
                };

                custom = mkOption {
                  description = "custom list of string that will not be shown.";
                  type = types.listOf types.str;
                  default = [];
                };
              };
            };
          };

          trash = mkOption {
            description = "configuration options for trashing";
            default = {};
            type = types.submodule {
              options = {
                cmd = mkOption {
                  description = "the command used to trash items (must be installed on your system)";
                  type = types.path;
                  default = "${pkgs.trash-cli}/bin/trash";
                };

                require_confirm = mkOption {
                  description = "show a prompt before trashing takes place.";
                  type = types.bool;
                  default = true;
                };
              };
            };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable (let
    mkVimBool = val:
      if val
      then 1
      else 0;
  in {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-tree-lua
      (
        if cfg.devIcons
        then nvim-web-devicons
        else null
      )
    ];

    vim.nnoremap = {
      "<leader>pt" = "<cmd>NvimTreeToggle<cr>";
      "<leader>ft" = "<cmd>NvimTreeToggle<cr>";
    };

    vim.globals = {
      "nvim_tree_side" = cfg.treeSide;
      "nvim_tree_width" = cfg.treeWidth;
      "nvim_tree_auto_ignore_ft" = cfg.ignoreFileTypes;
      "nvim_tree_quit_on_open" = mkVimBool cfg.closeOnFileOpen;
      "nvim_tree_indent_markers" = mkVimBool cfg.indentMarkers;
      "nvim_tree_add_trailing" = mkVimBool cfg.trailingSlash;
      "nvim_tree_group_empty" = mkVimBool cfg.groupEmptyFolders;
    };

    vim.luaConfigRC = ''
      require('nvim-tree').setup ${optionsToLua cfg.setup}
    '';
  });
}
