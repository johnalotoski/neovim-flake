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
    fidget = mkEnableOption "Fidget LSP Status support";
    gleam = mkEnableOption "Gleam";
    go = mkEnableOption "Go Language Support";
    haskellLspConfig = mkEnableOption "Haskell support via nvim-lspconfig plugin";
    haskellTools = mkEnableOption "Haskell support via haskell-tools plugin";
    html = mkEnableOption "HTML support";
    json = mkEnableOption "JSON";
    lightbulb = mkEnableOption "Light Bulb";
    mint = mkEnableOption "Mint support";
    nickel = mkEnableOption "Nickel Language Support";
    nix = mkEnableOption "Nix Language Support";
    nu = mkEnableOption "Nushell support";
    python = mkEnableOption "Python Support";
    rego = mkEnableOption "rego support";
    ruby = mkEnableOption "Ruby Support";
    rust = mkEnableOption "Rust Support";
    shellcheck = mkEnableOption "Shellcheck support";
    terraform = mkEnableOption "Terraform Support";
    tex = mkEnableOption "TeX support";
    typescript = mkEnableOption "Typescript/Javascript Support";
    variableDebugPreviews = mkEnableOption "Variable previews";
    vimscript = mkEnableOption "Vim Script Support";
    yaml = mkEnableOption "YAML support";
    zig = mkEnableOption "Zig support";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = assert assertMsg (!(cfg.haskellLspConfig && cfg.haskellTools))
    "Both config.vim.lsp.haskellLspConfig and config.vim.lsp.HaskellTools cannot be enabled at the same time due to plugin conflicts.";
    with pkgs.neovimPlugins;
      [
        cmp-buffer
        cmp-cmdline
        cmp_luasnip
        cmp-nvim-lsp
        cmp-path
        copilot-vim
        lsp_signature
        LuaSnip
        no-neck-pain
        nvim-cmp
        nvim-dap
        nvim-jqx
        nvim-lspconfig
        pkgs.nvim-treesitter-withAllGrammars
        telescope-dap
        vim-cue
        vim-just
        vim-ormolu
        vim-slim
      ]
      ++ (lib.optional cfg.crystal vim-crystal)
      ++ (lib.optional cfg.elixir elixir-nvim)
      ++ (lib.optional cfg.fidget fidget-nvim)
      ++ (lib.optional cfg.go vim-go)
      ++ (lib.optional cfg.haskellTools haskell-tools)
      ++ (lib.optional cfg.lightbulb nvim-lightbulb)
      ++ (lib.optional cfg.mint vim-mint)
      ++ (lib.optional cfg.nickel vim-nickel)
      ++ (lib.optional cfg.nix vim-nix)
      ++ (lib.optionals cfg.nu [null-ls-nvim nvim-nu])
      ++ (lib.optional cfg.variableDebugPreviews nvim-dap-virtual-text)
      ++ (lib.optional cfg.zig zig-vim);

    vim.configRC = ''
      ${optionalString cfg.variableDebugPreviews ''
        let g:dap_virtual_text = v:true
      ''}

      let g:completion_enable_auto_popup = 1

      let g:ormolu_command="fourmolu"
      let g:ormolu_options=["--no-cabal"]
      let g:ormolu_suppress_stderr=1
    '';

    vim.nnoremap =
      {
        # Lua mappings
        "<leader>lA" = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        "<leader>lD" = "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>";
        "<leader>le" = "<cmd>lua require('telescope.builtin').diagnostics({bufnr=0})<CR>";
        "<leader>lE" = "<cmd>lua require('telescope.builtin').diagnostics()<CR>";
        "<leader>lI" = "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>";
        "<leader>lr" = "<cmd>lua require('telescope.builtin').lsp_references()<CR>";
        "<leader>lR" = "<cmd>lua vim.lsp.buf.rename()<CR>";
        "<leader>ls" = "<cmd>lua vim.diagnostic.setloclist()<CR>";
        "[d" = "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>";
        "]d" = "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>";

        # Buffer mappings
        "<f2>" = "<cmd>lua vim.lsp.buf.rename()<CR>";
        "<leader>bk" = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
        "<leader>bK" = "<cmd>lua vim.lsp.buf.hover()<CR>";
        "<leader>bf" = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";

        # Dap mappings
        "<f10>" = "<cmd>lua require('dap').step_over()<CR>";
        "<f11>" = "<cmd>lua require('dap').step_into()<CR>";
        "<f12>" = "<cmd>lua require('dap').step_out()<CR>";
        "<f5>" = "<cmd>lua require('dap').continue()<CR>";
        "<f9>" = "<cmd>lua require('dap').repl.open()<CR>";

        # Telescope dap mappings
        "<leader>dc" = "<cmd>Telescope dap commands<CR>";
        "<leader>db" = "<cmd>Telescope dap list_breakpoints<CR>";
        "<leader>dv" = "<cmd>Telescope dap variables<CR>";
        "<leader>df" = "<cmd>Telescope dap frames<CR>";
        "<leader>dt" = "<cmd>lua require('dap').toggle_breakpoint()<CR>";

        # Misc
        "<leader>t" = "<cmd>terminal<CR>";
      }
      // optionalAttrs cfg.haskellTools {
        "<leader>hc" = "<cmd>lua vim.lsp.codelens.run()<CR>";
        "<leader>he" = "<cmd>lua require('haskell-tools').lsp.buf_eval_all()<CR>";
        "<leader>hh" = "<cmd>lua vim.lsp.buf.hover()<CR>";
        "<leader>hH" = "<cmd>checkhealth haskell-tools<CR>";
        "<leader>hll0" = "<cmd>Haskell log setLevel off<CR>";
        "<leader>hll1" = "<cmd>Haskell log setLevel error<CR>";
        "<leader>hll2" = "<cmd>Haskell log setLevel warn<CR>";
        "<leader>hll3" = "<cmd>Haskell log setLevel info<CR>";
        "<leader>hll4" = "<cmd>Haskell log setLevel debug<CR>";
        "<leader>hll5" = "<cmd>Haskell log setLevel trace<CR>";
        "<leader>hlh" = "<cmd>Haskell log openHlsLog<CR>";
        "<leader>hlt" = "<cmd>Haskell log openLog<CR>";
        "<leader>hLr" = "<cmd>Hls restart<CR>";
        "<leader>hLs" = "<cmd>Hls start<CR>";
        "<leader>hLS" = "<cmd>Hls stop<CR>";
        "<leader>hpc" = "<cmd>Haskell packageCabal<CR>";
        "<leader>hpp" = "<cmd>Haskell projectFile<CR>";
        "<leader>hpy" = "<cmd>Haskell packageYaml<CR>";
        "<leader>hrf" = "<cmd>lua (function() require('haskell-tools').repl.toggle(vim.api.nvim_buf_get_name(0)) end)()<CR>";
        "<leader>hri" = "<cmd>Haskell repl cword_info<CR>";
        "<leader>hrq" = "<cmd>lua require('haskell-tools').repl.quit()<CR>";
        "<leader>hrr" = "<cmd>Haskell repl reload<CR>";
        "<leader>hrt" = "<cmd>Haskell repl cword_type<CR>";
        "<leader>hrT" = "<cmd>lua require('haskell-tools').repl.toggle()<CR>";
        "<leader>hs" = "<cmd>lua require('haskell-tools').hoogle.hoogle_signature()<CR>";
        "<leader>htf" = "<cmd>Telescope ht package_hsfiles<CR>";
        "<leader>htF" = "<cmd>Telescope ht package_files<CR>";
        "<leader>htg" = "<cmd>Telescope ht package_hsgrep<CR>";
        "<leader>htG" = "<cmd>Telescope ht package_grep<CR>";
        "<leader>htt" = "<cmd>Telescope tags<CR>";
        "<leader>htT" = "<cmd>Telescope current_buffer_tags<CR>";
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
      local capabilities = require('cmp_nvim_lsp').default_capabilities(
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

      ${optionalString cfg.nu ''
        require("nu").setup({})
        require("null-ls").setup({})
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
        setup_cmd("ts_ls", {'${pkgs.tsserver}/bin/typescript-language-server', '--stdio'})
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

      ${optionalString cfg.fidget ''
        require("fidget").setup()
      ''}

      ${optionalString cfg.haskellLspConfig ''
        lspconfig.hls.setup{
          capabilities = capabilities;
          filetypes = { "haskell", "lhaskell", "cabalproject" };
          cmd = { "haskell-language-server", "--lsp" };
          settings = {
            haskell = {
              formattingProvider = "fourmolu"
            }
          };
        }
      ''}

      ${optionalString (cfg.haskellTools && config.vim.fuzzyfind.telescope.enable) ''
        require('telescope').load_extension('ht')
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

      ${optionalString cfg.zig ''
        setup("zls")
      ''}

      ${optionalString cfg.gleam ''
        setup("gleam")
      ''}

      ${optionalString cfg.elixir ''
        require("elixir").setup({
          nextls = {enable = false},
          elixirls = {enable = true},
          projectionist = {enable = true},
        })
      ''}

      ${optionalString config.vim.editor.whichKey ''
        require("which-key").add({
          { "<leader>l", group = "Lua" },
          { "<leader>lA", desc = "action" },
          { "<leader>lD", desc = "definitions" },
          { "<leader>le", desc = "diagnostics" },
          { "<leader>lE", desc = "diagnosticsAll" },
          { "<leader>lI", desc = "implementations" },
          { "<leader>lr", desc = "references" },
          { "<leader>lR", desc = "rename" },
          { "<leader>ls", desc = "setLocList" },
          { "<leader>lg", group = "goto" },
          { "<leader>lg[", desc = "gotoPrev ([d)", proxy = "[d" },
          { "<leader>lg]", desc = "gotoNext (]d)", proxy = "]d" },

          { "<leader>b", group = "Buffers" },
          { "<leader>ba", "<Cmd>BufferPrevious<CR>", desc = "bufPrev <A-,>" },
          { "<leader>bA", "<Cmd>BufferMovePrev<CR>", desc = "bufMovePrev <A-<>" },
          { "<leader>bb", desc = "orderByBufNum" },
          { "<leader>bB", group = "BufList", expand = function() return require("which-key.extras").expand.buf() end },
          { "<leader>bc", "<Cmd>BufferClose<CR>", desc = "bufClose <A-c>" },
          { "<leader>bd", desc = "orderByDir" },
          { "<leader>bD", "<Cmd>BufferClose<CR>", desc = "bufDel <C-A-p>" },
          { "<leader>bf", desc = "format" },
          { "<leader>bk", desc = "signatureHelp" },
          { "<leader>bK", desc = "hover" },
          { "<leader>bl", desc = "orderByLang" },
          { "<leader>bt", "<Cmd>BufferPin<CR>", desc = "bufPin <A-p>" },
          { "<leader>bT", "<Cmd>BufferPick<CR>", desc = "bufPick <C-p>" },
          { "<leader>bw", desc = "orderByWinNum" },
          { "<leader>bW", group = "WinList", expand = function() return require("which-key.extras").expand.win() end },
          { "<leader>bz", "<Cmd>BufferNext<CR>", desc = "bufNext <A-.>" },
          { "<leader>bZ", "<Cmd>BufferMoveNext<CR>", desc = "bufMoveNext <A->>" },
          { "<leader>b<f2>", desc = "rename", proxy = "<f2>" },

          { "<leader>d", group = "Debug" },
          { "<leader>dc", desc = "commands" },
          { "<leader>db", desc = "breakpoints" },
          { "<leader>dv", desc = "variables" },
          { "<leader>df", desc = "frames" },
          { "<leader>dt", desc = "toggleBreakpoint" },
          { "<leader>d<f10>", desc = "stepOver", proxy = "<f10>" },
          { "<leader>d<f11>", desc = "stepInto", proxy = "<f11>" },
          { "<leader>d<f12>", desc = "stepOut", proxy = "<f12>" },
          { "<leader>d<f5>", desc = "continue", proxy = "<f5>" },
          { "<leader>d<f9>", desc = "repl", proxy = "<f9>" },

          ${optionalString cfg.haskellTools ''
          { "<leader>h", group = "Haskell" },
          { "<leader>hc", desc = "codeLens" },
          { "<leader>he", desc = "evalSnippets" },
          { "<leader>hh", desc = "hover" },
          { "<leader>hH", desc = "healthcheck" },
          { "<leader>hl", group = "Logs" },
          { "<leader>hlh", desc = "openHlsLog" },
          { "<leader>hll", group = "HaskellTools LogLevel" },
          { "<leader>hll0", desc = "off" },
          { "<leader>hll1", desc = "error" },
          { "<leader>hll2", desc = "warn" },
          { "<leader>hll3", desc = "info" },
          { "<leader>hll4", desc = "debug" },
          { "<leader>hll5", desc = "trace" },
          { "<leader>hlt", desc = "openHtLog" },
          { "<leader>hL", group = "HLS" },
          { "<leader>hLr", desc = "restart" },
          { "<leader>hLs", desc = "start" },
          { "<leader>hLS", desc = "stop" },
          { "<leader>hp", group = "ProjectFiles" },
          { "<leader>hpc", desc = "packageCabal" },
          { "<leader>hpp", desc = "projectFile" },
          { "<leader>hpy", desc = "packageYaml" },
          { "<leader>hr", group = "Repl" },
          { "<leader>hrf", desc = "currentFile" },
          { "<leader>hri", desc = "cursorWordInfo" },
          { "<leader>hrq", desc = "quit" },
          { "<leader>hrr", desc = "reload" },
          { "<leader>hrt", desc = "cursorWordType" },
          { "<leader>hrT", desc = "toggle" },
          { "<leader>hs", desc = "hoogleSearch" },
          { "<leader>ht",  group = "Haskell Telescope" },
          { "<leader>htf", desc = "findPkgHsFiles(hasBug)" },
          { "<leader>htF", desc = "findPkgFiles" },
          { "<leader>htg", desc = "grepPkgHsFiles" },
          { "<leader>htG", desc = "grepPkgFiles" },
          { "<leader>htt", desc = "tags" },
          { "<leader>htT", desc = "currentBufferTags" },
        ''}
        })
      ''}

      -- This enforces TS features when some languages won't automatically do it
      -- Example: gleam, https://github.com/nvim-treesitter/nvim-treesitter/issues/6602
      ${builtins.concatStringsSep "\n\n" (map (
        feat: ''
          vim.api.nvim_create_autocmd({"BufEnter"}, {
              pattern = {"*"},
              command = "TSBufEnable ${feat}",
          })
        ''
      ) ["highlight" "indent" "incremental_selection"])}
    '';
  };
}
