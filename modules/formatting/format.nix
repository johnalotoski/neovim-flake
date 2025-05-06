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
          elixir = treefmt,
          erlang = treefmt,
          gleam = treefmt,
          go = treefmt,
          javascript = treefmt,
          lua = treefmt,
          mint = treefmt,
          nix = treefmt,
          rego = treefmt,
          ruby = treefmt,
          rust = treefmt,
          vim = treefmt,
        }
      })
    '';
  };
}
