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

    bash = mkEnableOption "Enable Bash Support";
    clang = mkEnableOption "Enable C/C++ with clang";
    cmake = mkEnableOption "Enable CMake";
    crystal = mkEnableOption "Enable Crystal";
    css = mkEnableOption "Enable CSS support";
    docker = mkEnableOption "Enable Docker support";
    gleam = mkEnableOption " Enable Gleam";
    go = mkEnableOption "Enable Go Language Support";
    html = mkEnableOption "Enable HTML support";
    idris2 = mkEnableOption "Enable Idris2 Support";
    json = mkEnableOption "Enable JSON";
    mint = mkEnableOption "Enable Mint support";
    nickel = mkEnableOption "Enable Nickel Language Support";
    nix = mkEnableOption "Enable Nix Language Support";
    python = mkEnableOption "Enable Python Support";
    rego = mkEnableOption "Enable rego support";
    ruby = mkEnableOption "Enable Ruby Support";
    rust = mkEnableOption "Enable Rust Support";
    shellcheck = mkEnableOption "Enable Shellcheck support";
    terraform = mkEnableOption "Enable Terraform Support";
    tex = mkEnableOption "Enable TeX support";
    typescript = mkEnableOption "Enable Typescript/Javascript Support";
    vimscript = mkEnableOption "Enable Vim Script Support";
    yaml = mkEnableOption "Enable YAML support";
    zig = mkEnableOption "Enable Zig support";

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

      cmp-buffer
      cmp-cmdline
      cmp_luasnip
      cmp-nvim-lsp
      cmp-path
      LuaSnip
      nvim-cmp

      nvim-jqx
      vim-crystal
      vim-cue
      vim-go
      vim-mint
      vim-nickel
      vim-slim
      zig-vim
      gleam-vim
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
      "<leader>lA" = "<cmd>lua vim.lsp.buf.code_action()<CR>";

      "<leader>lD" = "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>";
      "<leader>lI" = "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>";
      "<leader>le" = "<cmd>lua require('telescope.builtin').diagnostics({bufnr=0})<cr>";
      "<leader>lE" = "<cmd>lua require('telescope.builtin').diagnostics()<cr>";
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

      local merge = function(a, b)
        local merged = {}
        for k, v in pairs(a) do merged[k] = v end
        for k, v in pairs(b) do merged[k] = v end
        return merged
      end

      local setup = function(name, args)
        return lspconfig[name].setup(merge({capabilities = capabilities}, (args or {})))
      end

      local setup_cmd = function(name, cmd)
        return setup(name, { cmd = cmd })
      end

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

      cmp.setup {
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
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          -- { name = 'vsnip' },
          { name = 'luasnip' },
          -- { name = 'ultisnips' },
          -- { name = 'snippy' },
        }, {
          { name = 'buffer' },
        }
      }

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

      require("lsp_signature").setup {}

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

        setup("regols", {})
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
        setup("nickel_ls")
      ''}

      ${optionalString cfg.crystal ''
        setup("crystalline")
      ''}

      ${optionalString cfg.bash ''
        setup_cmd("bashls", {"${pkgs.bashls}/bin/bash-language-server", "start"})
      ''}

      ${optionalString cfg.shellcheck ''
        setup("efm", {
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
        })
      ''}

      ${optionalString cfg.go ''
        setup("gopls")

        dap.adapters.go = function(callback, config)
          local handle
          local pid_or_err
          local port = 38697
          handle, pid_or_err = vim.loop.spawn(
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
        setup_cmd("rnix", {"${pkgs.rnix-lsp}/bin/rnix-lsp"})
      ''}

      ${optionalString cfg.ruby ''
        setup_cmd("solargraph", {'${pkgs.solargraph}/bin/solargraph', 'stdio'})
      ''}

      ${optionalString cfg.rust ''
        setup("rust_analyzer")
      ''}

      ${optionalString cfg.terraform ''
        setup_cmd("terraformls", {'${pkgs.terraform-ls}/bin/terraform-ls', 'serve'})
      ''}

      ${optionalString cfg.typescript ''
        setup_cmd("tsserver", {'${pkgs.tsserver}/bin/typescript-language-server', '--stdio'})
      ''}

      ${optionalString cfg.vimscript ''
        setup_cmd("vimls", {'${pkgs.vimls}/bin/vim-language-server', '--stdio'})
      ''}

      ${optionalString cfg.yaml ''
        setup_cmd("yamlls", {'${pkgs.yamlls}/bin/yaml-language-server', '--stdio'})
      ''}

      ${optionalString cfg.docker ''
        setup_cmd("dockerls", {'${pkgs.dockerls}/bin/docker-language-server', '--stdio'})
      ''}

      ${optionalString cfg.css ''
        setup_cmd("cssls", {'${pkgs.cssls}/bin/css-languageserver', '--stdio'})
      ''}

      ${optionalString cfg.html ''
        setup_cmd("html", {'${pkgs.htmlls}/bin/html-languageserver', '--stdio'})
      ''}

      ${optionalString cfg.json ''
        setup_cmd("jsonls", {'${pkgs.jsonls}/bin/json-languageserver', '--stdio'})
      ''}

      ${optionalString cfg.tex ''
        setup_cmd("texlab", {'${pkgs.texlab}/bin/texlab'})
      ''}

      ${optionalString cfg.clang ''
        setup_cmd("clangd", {'${pkgs.clang-tools}/bin/clangd', '--background-index'})
      ''}

      ${optionalString cfg.cmake ''
        setup_cmd("cmake", {'${pkgs.cmake-language-server}/bin/cmake-language-server'})
      ''}

      ${optionalString cfg.python ''
        setup_cmd("pyright", {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"})
      ''}

      ${optionalString cfg.mint ''
        setup("mint")
      ''}

      ${optionalString cfg.idris2 ''
        setup("idris2_lsp")
      ''}

      ${optionalString cfg.zig ''
        setup("zls")
      ''}

      ${optionalString cfg.gleam ''
        setup("gleam")
      ''}
    '';
  };
}
