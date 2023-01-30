{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in {
  options.vim.lsp = {
    enable = mkEnableOption "LSP support";

    bash = mkEnableOption "Bash Support";
    clang = mkEnableOption "C/C++ with clang";
    cmake = mkEnableOption "CMake";
    crystal = mkEnableOption "Crystal";
    css = mkEnableOption "CSS support";
    docker = mkEnableOption "Docker support";
    elixir = mkEnableOption "Elixir support";
    gleam = mkEnableOption "Gleam";
    go = mkEnableOption "Go Language Support";
    haskell = mkEnableOption "Haskell support";
    html = mkEnableOption "HTML support";
    idris2 = mkEnableOption "Idris2 Support";
    json = mkEnableOption "JSON";
    mint = mkEnableOption "Mint support";
    nickel = mkEnableOption "Nickel Language Support";
    nix = mkEnableOption "Nix Language Support";
    python = mkEnableOption "Python Support";
    rego = mkEnableOption "rego support";
    ruby = mkEnableOption "Ruby Support";
    rust = mkEnableOption "Rust Support";
    shellcheck = mkEnableOption "Shellcheck support";
    terraform = mkEnableOption "Terraform Support";
    tex = mkEnableOption "TeX support";
    typescript = mkEnableOption "Typescript/Javascript Support";
    vimscript = mkEnableOption "Vim Script Support";
    yaml = mkEnableOption "YAML support";
    zig = mkEnableOption "Zig support";
    lightbulb = mkEnableOption "Light Bulb";
    variableDebugPreviews = mkEnableOption "variable previews";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins;
      [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars

        # nvim-treesitter
        # nvim-treesitter-context
        cmp-buffer
        cmp-cmdline
        cmp_luasnip
        cmp-nvim-lsp
        cmp-path
        lsp_signature
        LuaSnip
        no-neck-pain
        nvim-cmp
        nvim-dap
        nvim-jqx
        nvim-lspconfig
        telescope-dap
        vim-cue
        vim-just
        vim-slim
      ]
      ++ (lib.optional cfg.lightbulb nvim-lightbulb)
      ++ (lib.optional cfg.variableDebugPreviews nvim-dap-virtual-text)
      ++ (lib.optional cfg.nix vim-nix)
      ++ (lib.optional cfg.crystal vim-crystal)
      ++ (lib.optional cfg.elixir elixir-nvim)
      ++ (lib.optional cfg.gleam gleam-vim)
      ++ (lib.optional cfg.go vim-go)
      ++ (lib.optional cfg.mint vim-mint)
      ++ (lib.optional cfg.nickel vim-nickel)
      ++ (lib.optional cfg.zig zig-vim);

    vim.configRC = ''
      " Use <Tab> and <S-Tab> to navigate through popup menu
      inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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
      "<leader>bf" = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";

      "[d" = "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>";
      "]d" = "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>";

      "<leader>q" = "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>";

      "<f10>" = "<cmd>lua require('dap').step_over()<cr>";
      "<f11>" = "<cmd>lua require('dap').step_into()<cr>";
      "<f12>" = "<cmd>lua require('dap').step_out()<cr>";
      "<f5>" = "<cmd>lua require('dap').continue()<cr>";
      "<f9>" = "<cmd>lua require('dap').repl.open()";

      "<leader>dc" = "<cmd>Telescope dap commands<cr>";
      "<leader>db" = "<cmd>Telescope dap list_breakpoints<cr>";
      "<leader>dv" = "<cmd>Telescope dap variables<cr>";
      "<leader>df" = "<cmd>Telescope dap frames<cr>";
      "<leader>dt" = "<cmd>lua require('dap').toggle_breakpoint()<cr>";
    };

    vim.globals = {};

    vim.luaConfigRC = ''
      local lspconfig = require('lspconfig')
      local dap = require('dap')

      -- vim.lsp.set_log_level("debug")

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
        parser_install_dir = vim.env.HOME .. "/.local/share/nvim/site/parser",
        additional_vim_regex_highlighting = false,
        auto_install = false,
        sync_install = true,
        highlight = {
          enable = true,
          disable = {},
        },
        indent = {
          enable = true,
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

      vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
          ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
          ['<Down>'] = cmp.mapping.select_next_item(select_opts),
          ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
          ['<C-d>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, {'i', 's'}),
          ['<C-b>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {'i', 's'}),
          ['<Tab>'] = cmp.mapping(function(fallback)
            local col = vim.fn.col('.') - 1

            if cmp.visible() then
              cmp.select_next_item(select_opts)
            elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
              fallback()
            else
              cmp.complete()
            end
          end, {'i', 's'}),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item(select_opts)
            else
              fallback()
            end
          end, {'i', 's'}),
        },
        sources = cmp.config.sources {
          { name = 'path' },
          { name = 'nvim_lsp', keyword_length = 1 },
          { name = 'luasnip', keyword_length = 1 },
          { name = 'buffer', keyword_length = 1 },
        },
        window = {
          documentation = cmp.config.window.bordered()
        },
        formatting = {
          fields = {'menu', 'abbr', 'kind'},
          format = function(entry, item)
            local menu_icon = {
              nvim_lsp = 'λ',
              luasnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
            }

            item.menu = menu_icon[entry.source.name]
            return item
          end,
        },
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

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {border = 'rounded'}
      )

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {border = 'rounded'}
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
        setup_cmd("nil_ls", {"${pkgs.nil}/bin/nil"})
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

      ${optionalString cfg.haskell ''
        setup("hls")
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

      ${optionalString cfg.elixir ''
        local elixir = require("elixir")
        elixir.setup({
          settings = elixir.settings({
            fetchDeps = true,
            suggestSpecs = true,
          })
        })
        setup_cmd("elixirls", {"${pkgs.elixirls}/language_server.sh"})
      ''}

        ${builtins.concatStringsSep "\n\n" (map (
        feat: ''
          vim.api.nvim_create_autocmd({ "BufEnter"}, {
              pattern = { "*" },
              command = "TSBufEnable ${feat}",
          })
        ''
      ) ["highlight" "indent" "incremental_selection"])}
    '';
  };
}
