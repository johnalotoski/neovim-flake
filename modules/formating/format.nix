{pkgs, ...}: {
  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [formatter-nvim];

    vim.configRC = ''
      augroup FormatAutogroup
        autocmd!
        autocmd BufWritePost * silent! FormatWrite
      augroup END
    '';

    vim.luaConfigRC = ''
      local treefmt = {
        function()
          return {
            exe = "treefmt",
            args = {"--stdin", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
            stdin = true,
          }
        end
      }

      require("formatter").setup({
        filetype = {
          crystal = treefmt,
          cue = treefmt,
          go = treefmt,
          javascript = treefmt,
          lua = treefmt,
          mint = treefmt,
          nix = treefmt,
          rego = treefmt,
          ruby = treefmt,
          rust = treefmt,
          vim = treefmt,
          erlang = treefmt,
          gleam = treefmt,
        }
      })
    '';

    /*
     rust = {{ cmd = {"rustfmt --edition 2018"} }},
            cue = {{ cmd = {"${pkgs.cue}/bin/cue fmt"} }},
            mint = {{ cmd = {"mint format"} }},
            nix = {{
              cmd = {
                "${pkgs.statix}/bin/statix fix",
                "${pkgs.treefmt}/bin/treefmt",
              }
            }},
            rego = {{ cmd = {"${pkgs.treefmt}/bin/treefmt"} }},
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
              tempfile_postfix = ".tmp",
            }},
            javascript = {{
              cmd = {"prettier --no-semi -w"},
              tempfile_postfix = ".tmp",
            }},
          }
        '';
     */
  };
}
