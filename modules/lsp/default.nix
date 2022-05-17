{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;

  debugpy = pkgs.python3.withPackages (pyPkg: with pyPkg; [debugpy]);
in {
  options.vim.lsp = {
    enable = mkEnableOption "Enable lsp support";

    bash = mkEnableOption "Enable Bash Language Support";
    clang = mkEnableOption "Enable C/C++ with clang";
    cmake = mkEnableOption "Enable CMake";
    crystal = mkEnableOption "Enable Crystal";
    css = mkEnableOption "Enable css support";
    docker = mkEnableOption "Enable docker support";
    go = mkEnableOption "Enable Go Language Support";
    html = mkEnableOption "Enable html support";
    idris2 = mkEnableOption "Enable Idris2 Support";
    json = mkEnableOption "Enable JSON";
    mint = mkEnableOption "Enable Mint support";
    nix = mkEnableOption "Enable NIX Language Support";
    nickel = mkEnableOption "Enable Nickel Language Support";
    python = mkEnableOption "Enable Python Support";
    ruby = mkEnableOption "Enable Ruby Support";
    rust = mkEnableOption "Enable Rust Support";
    shellcheck = mkEnableOption "Enable Shellcheck support";
    terraform = mkEnableOption "Enable Terraform Support";
    tex = mkEnableOption "Enable tex support";
    typescript = mkEnableOption "Enable Typescript/Javascript Support";
    vimscript = mkEnableOption "Enable Vim Script Support";
    yaml = mkEnableOption "Enable yaml support";
    rego = mkEnableOption "Enable rego support";
    zig = mkEnableOption "Enable zig support";

    lightbulb = mkEnableOption "Enable Light Bulb";
    variableDebugPreviews = mkEnableOption "Enable variable previews";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-lspconfig
      nvim-dap
      (
        if cfg.nix
        then vim-nix
        else null
      )
      telescope-dap
      (
        if cfg.lightbulb
        then nvim-lightbulb
        else null
      )
      (
        if cfg.variableDebugPreviews
        then nvim-dap-virtual-text
        else null
      )
      nvim-treesitter
      nvim-treesitter-context
      lsp_signature
      vim-crystal
      vim-nickel

      cmp-buffer
      cmp-cmdline
      cmp_luasnip
      cmp-nvim-lsp
      cmp-path
      LuaSnip
      nvim-cmp

      nvim-jqx
      vim-cue
      vim-mint
      vim-go
      zig-vim
    ];

    vim.configRC = ''
      " Use <Tab> and <S-Tab> to navigate through popup menu
      inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

      " Set completeopt to have a better completion experience
      set completeopt=menu,menuone,noinsert,noselect

      ${optionalString cfg.variableDebugPreviews ''
        let g:dap_virtual_text = v:true
      ''}

      let g:completion_enable_auto_popup = 1
    '';

    vim.nnoremap = {
      "<f2>" = "<cmd>lua vim.lsp.buf.rename()<cr>";
      "<leader>lR" = "<cmd>lua vim.lsp.buf.rename()<cr>";
      "<leader>lr" = "<cmd>lua require('telescope.builtin').lsp_references()<CR>";
      "<leader>lA" = "<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>";

      "<leader>lD" = "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>";
      "<leader>lI" = "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>";
      "<leader>le" = "<cmd>lua require('telescope.builtin').lsp_document_diagnostics()<cr>";
      "<leader>lE" = "<cmd>lua require('telescope.builtin').lsp_workspace_diagnostics()<cr>";
      "<leader>bk" = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
      "<leader>bK" = "<cmd>lua vim.lsp.buf.hover()<CR>";
      "<leader>bf" = "<cmd>lua vim.lsp.buf.formatting()<CR>";

      "[d" = "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>";
      "]d" = "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>";

      "<leader>q" = "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>";

      "<f10>" = "<cmd>lua require('dap').step_over()<cr>";
      "<f11>" = "<cmd>lua require('dap').step_into()<cr>";
      "<f12>" = "<cmd>lua require('dap').step_out()<cr>";
      "<f5>" = "<cmd>lua require('dap').continue()<cr>";
      "<leader>b" = "<cmd>lua require('dap').toggle_breakpoint()<cr>";
      "<f9>" = "<cmd>lua require('dap').repl.open()";

      "<leader>dc" = "<cmd>Telescope dap commands<cr>";
      "<leader>db" = "<cmd>Telescope dap list_breakpoints<cr>";
      "<leader>dv" = "<cmd>Telescope dap variables<cr>";
      "<leader>df" = "<cmd>Telescope dap frames<cr>";
    };

    vim.globals = {};

    vim.luaConfigRC = ''
      local lspconfig = require('lspconfig')
      local dap = require('dap')

      vim.lsp.set_log_level("debug")

      --Tree sitter config
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          disable = {},
        },
        rainbow = {
          enable = true,
          extended_mode = true,
        },
         autotag = {
          enable = true,
        },
        context_commentstring = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      }

      vim.cmd [[set foldmethod=expr]]
      vim.cmd [[set foldlevel=10]]
      vim.cmd [[set foldexpr=nvim_treesitter#foldexpr()]]

      -- Setup nvim-cmp.
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body)
            luasnip.lsp_expand(args.body)
            -- require('snippy').expand_snippet(args.body)
            -- vim.fn["UltiSnips#Anon"](args.body)
          end,
        },
        mapping = {
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          -- { name = 'vsnip' },
          { name = 'luasnip' },
          -- { name = 'ultisnips' },
          -- { name = 'snippy' },
        }, {
          { name = 'buffer' },
        })
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline('/', {
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })

      -- Setup lspconfig.
      local capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = "single",
          focusable = false,
          close_events = {"CursorMoved", "CursorMovedI", "BufHidden", "BufLeave", "InsertCharPre"},
        }
      )

      require("lsp_signature").setup({})

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          -- Enable underline, use default values
          underline = true,
          -- Enable virtual text, override spacing to 2
          virtual_text = {
            spacing = 2,
            prefix = '~',
          },
          -- Use a function to dynamically turn signs off
          -- and on, using buffer local variables
          signs = function(bufnr, client_id)
            local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, 'show_signs')
            -- No buffer local variable set, so just enable by default
            if not ok then
              return true
            end

            return result
          end,
          -- Disable a feature
          update_in_insert = false,
        }
      )

      local function split_on(s, delimiter)
        local result = {}
        local from = 1
        local delim_from, delim_to = string.find(s, delimiter, from)
        while delim_from do
          table.insert(result, string.sub(s, from, delim_from - 1))
          from = delim_to + 1
          delim_from, delim_to = string.find(s, delimiter, from)
        end
        table.insert(result, string.sub(s, from))
        return result
      end

      local diagnostic_foramt = function(diagnostic)
        return string.format("%s: %s", diagnostic.source, split_on(diagnostic.message, "\n")[1])
      end

      vim.diagnostic.config({ virtual_text = { format = diagnostic_foramt }, severity_sort = true })

      vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

      ${optionalString cfg.rego ''
        local configs = require('lspconfig.configs')
        local util = require('lspconfig.util')
        if not configs.regols then
          configs.regols = {
            default_config = {
              cmd = {'${pkgs.regols}/bin/regols'};
              filetypes = { 'rego' };
              root_dir = util.root_pattern(".git");
            }
          }
        end
        lspconfig.regols.setup{}
      ''}

      ${optionalString cfg.lightbulb ''
        require('nvim-lightbulb').update_lightbulb {
          sign = {
            enabled = true,
            priority = 10,
          },
          float = {
            enabled = false,
            text = "💡",
            win_opts = {},
          },
          virtual_text = {
            enable = false,
            text = "💡",

          },
          status_text = {
            enabled = false,
            text = "💡",
            text_unavailable = ""
          }
        }
      ''}

      ${optionalString cfg.nickel ''
        lspconfig.nickel_ls.setup{
          capabilities = capabilities;
          cmd = {"nls"}
        }
      ''}

      ${optionalString cfg.crystal ''
        lspconfig.crystalline.setup{
          capabilities = capabilities;
          cmd = {"crystalline"}
        }
      ''}

      ${optionalString cfg.bash ''
        lspconfig.bashls.setup{
          capabilities = capabilities;
          cmd = {"${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start"}
        }
      ''}

      ${optionalString cfg.shellcheck ''
        lspconfig.efm.setup{
          capabilities = capabilities;
          cmd = {"${pkgs.efm-langserver}/bin/efm-langserver"};
          init_options = {
            documentFormatting = true,
            hover = true,
            documentSymbol = true,
            codeAction = true,
            completion = true,
          };
          filetypes = {"sh"};
          settings = {
            rootMarkers = {".git/"},
            languages = {
              sh = {
                {
                  lintCommand = '${pkgs.shellcheck}/bin/shellcheck -f gcc -x',
                  lintSource = 'shellcheck',
                  lintFormats= {'%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'},
                }
              }
            }
          }
        }
      ''}

      ${optionalString cfg.go ''
        lspconfig.gopls.setup{
          capabilities = capabilities;
          cmd = {"gopls"}
        }

        dap.adapters.go = function(callback, config)
          local handle
          local pid_or_err
          local port = 38697
          handle, pid_or_err =
            vim.loop.spawn(
            "dlv",
            {
              args = {"dap", "-l", "127.0.0.1:" .. port},
              detached = true
            },
            function(code)
              handle:close()
              print("Delve exited with exit code: " .. code)
            end
          )
          -- Wait 100ms for delve to start
          vim.defer_fn(
            function()
              --dap.repl.open()
              callback({type = "server", host = "127.0.0.1", port = port})
            end,
            100)


          --callback({type = "server", host = "127.0.0.1", port = port})
        end

        -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
        dap.configurations.go = {
          {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${"$"}{workspaceFolder}"
          },
          {
            type = "go",
            name = "Debug test", -- configuration for debugging test files
            request = "launch",
            mode = "test",
            program = "${"$"}{workspaceFolder}"
          },
        }
      ''}

      ${optionalString cfg.nix ''
        lspconfig.rnix.setup{
          capabilities = capabilities;
          cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"}
        }
      ''}

      ${optionalString cfg.ruby ''
        lspconfig.solargraph.setup{
          capabilities = capabilities;
          cmd = {'${pkgs.solargraph}/bin/solargraph', 'stdio'}
        }
      ''}

      ${optionalString cfg.rust ''
        lspconfig.rust_analyzer.setup{
          capabilities = capabilities;
          cmd = {'rust-analyzer'}
        }
      ''}

      ${optionalString cfg.terraform ''
        lspconfig.terraformls.setup{
          capabilities = capabilities;
          cmd = {'${pkgs.terraform-ls}/bin/terraform-ls', 'serve' }
        }
      ''}

      ${optionalString cfg.typescript ''
        lspconfig.tsserver.setup{
          capabilities = capabilities;
          cmd = {'${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio' }
        }
      ''}

      ${optionalString cfg.vimscript ''
        lspconfig.vimls.setup{
          capabilities = capabilities;
          cmd = {'${pkgs.nodePackages.vim-language-server}/bin/vim-language-server', '--stdio' }
        }
      ''}

      ${optionalString cfg.yaml ''
        lspconfig.yamlls.setup{
          capabilities = capabilities;
          cmd = {'${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server', '--stdio' }
        }
      ''}

      ${optionalString cfg.docker ''
        lspconfig.dockerls.setup{
          capabilities = capabilities;
          cmd = {'${pkgs.nodePackages.dockerfile-language-server-nodejs}/bin/docker-language-server', '--stdio' }
        }
      ''}

      ${optionalString cfg.css ''
        lspconfig.cssls.setup{
          capabilities = capabilities;
          cmd = {'${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver', '--stdio' };
          filetypes = { "css", "scss", "less" };
        }
      ''}

      ${optionalString cfg.html ''
        lspconfig.html.setup{
          capabilities = capabilities;
          cmd = {'${pkgs.nodePackages.vscode-html-languageserver-bin}/bin/html-languageserver', '--stdio' };
          filetypes = { "html" };
        }
      ''}

      ${optionalString cfg.json ''
        lspconfig.jsonls.setup{
          capabilities = capabilities;
          cmd = {'${pkgs.nodePackages.vscode-json-languageserver-bin}/bin/json-languageserver', '--stdio' };
          filetypes = { "json" };
        }
      ''}

      ${optionalString cfg.tex ''
        lspconfig.texlab.setup{
          capabilities = capabilities;
          cmd = {'${pkgs.texlab}/bin/texlab'}
        }
      ''}

      ${optionalString cfg.clang ''
        lspconfig.clangd.setup{
          capabilities = capabilities;
          cmd = {'${pkgs.clang-tools}/bin/clangd', '--background-index'};
          filetypes = { "c", "cpp", "objc", "objcpp" };
        }
      ''}

      ${optionalString cfg.cmake ''
        lspconfig.cmake.setup{
          capabilities = capabilities;
          cmd = {'${pkgs.cmake-language-server}/bin/cmake-language-server'};
          filetypes = { "cmake"};
        }
      ''}

      ${optionalString cfg.python ''
        lspconfig.pyright.setup{
          capabilities = capabilities;
          cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
        }
      ''}

      ${optionalString cfg.mint ''
        lspconfig.mint.setup{
          capabilities = capabilities;
          cmd = {'mint', 'ls'};
          filetypes = {'mint'};
        }
      ''}

      ${optionalString cfg.idris2 ''
        lspconfig.idris2_lsp.setup{
          capabilities = capabilities;
        }
      ''}

      ${optionalString cfg.zig ''
        lspconfig.zls.setup{
          capabilities = capabilities;
        }
      ''}
    '';
  };
}
