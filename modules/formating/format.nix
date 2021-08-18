{ pkgs, ... }: {
  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [ format-nvim ];

    vim.configRC = ''
      augroup Format
        autocmd!
        autocmd BufWritePost * FormatWrite
      augroup END
    '';

    vim.luaConfigRC = ''
      require("format").setup {
        ["*"] = {{ cmd = {"sed -i 's/[ \t]*$//'"} }},
        rust = {{ cmd = {"rustfmt --edition 2018"} }},
        cue = {{ cmd = {"${pkgs.cue}/bin/cue fmt"} }},
        mint = {{ cmd = {"mint format"} }},
        nix = {{ cmd = {"${pkgs.nixfmt}/bin/nixfmt"} }},
        crystal = {{ cmd = {"crystal tool format"} }},
        vim = {{
          cmd = {"luafmt -w replace"},
          start_pattern = "^lua << EOF$",
          end_pattern = "^EOF$"
        }},
        vimwiki = {{
          cmd = {"prettier -w --parser babel"},
          start_pattern = "^{{{javascript$",
          end_pattern = "^}}}$"
        }},
        lua = {{
          cmd = {
            function(file)
              return string.format("luafmt -l %s -w replace %s", vim.bo.textwidth, file)
            end
          }
        }},
        go = {{
          cmd = {"gofmt -w", "goimports -w"},
          tempfile_postfix = ".tmp"
        }},
        javascript = {{
          cmd = {"prettier -w", "./node_modules/.bin/eslint --fix"}
        }},
        markdown = {
          {cmd = {"prettier -w"}},
          {
            cmd = {"black"},
            start_pattern = "^```python$",
            end_pattern = "^```$",
            target = "current"
          }
        }
      }
    '';
  };
}
