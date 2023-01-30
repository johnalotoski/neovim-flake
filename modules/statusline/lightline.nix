{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.statusline.lightline;
in {
  options.vim.statusline.lightline = {
    enable = mkEnableOption "Enable lightline";

    theme = mkOption {
      default = "powerline";
      description = "Theme for light line.";
      type = types.enum [
        "wombat"
        "powerline"
        "jellybeans"
        "solarized dark"
        "solarized dark"
        "papercolor dark"
        "papercolor light"
        "seoul256"
        "one dark"
        "one light"
        "landscape"
      ];
    };
  };

  config = mkIf cfg.enable {
    vim = {
      startPlugins = with pkgs.neovimPlugins; [lightline-vim];
      globals.lightline = {
        colorscheme = cfg.theme;
        component_function.filename = "LightlineTruncatedFileName";
      };

      configRC = ''
        function! LightlineTruncatedFileName()
        let l:filePath = expand('%')
            if winwidth(0) > 100
                return l:filePath
            else
                return pathshorten(l:filePath)
            endif
        endfunction
      '';
    };
  };
}
