return {
	-- Mason untuk manajemen LSP & tools
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = function()
			require("mason").setup()
		end,
	},
	-- mason-lspconfig untuk install & setup LSP
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			ensure_installed = {
				"bashls", "cssls", "lua_ls", "ts_ls",
				"superhtml", "tailwindcss", "vuels", "jsonls", "yamlls",
				"sqlls",  "jdtls", "vimls","sourcery", "ruff",  "asm_lsp", "intelephense","marksman"
			},
			auto_install = true,
		},
	},

	-- nvim-cmp + snippet + completion sources

{
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "zbirenbaum/copilot-cmp",
    "windwp/nvim-autopairs", -- untuk autopairs integration
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    require("luasnip.loaders.from_vscode").lazy_load()

    -- Setup autopairs integration
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    cmp.setup({
      completion = {
        keyword_length = 1,
        completeopt = "menu,menuone,noselect,noinsert",
        autocomplete = { cmp.TriggerEvent.TextChanged },
      },
      performance = {
        debounce = 20,
        throttle = 20,
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
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
      }),
      sources = cmp.config.sources({
        { name = "copilot", priority = 1000 },
        { name = "nvim_lsp", priority = 900 },
        { name = "luasnip", priority = 800 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 300 },
        { name = "nvim_lua", priority = 250 },
        { name = "calc", priority = 200 },
        { name = "treesitter", priority = 150 },
        { name = "spell", priority = 100 },
        { name = "emoji", priority = 80 },
      }),
      window = {
        completion = cmp.config.window.bordered({
          max_item_count = 100,
          max_width = 30,
          max_height = 6,
          min_width = 20,
          min_height = 2,
          border = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        }),
        documentation = cmp.config.window.bordered({
          max_item_count = 100,
          max_width = 50,
          max_height = 10,
          min_width = 20,
          min_height = 2,
          border = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        }),
      },
      experimental = {
        ghost_text = {
          hl_group = "Comment",
          only_current_line = true,
        },
      },
      sorting = {
        comparators = {
          cmp.config.compare.score,
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
        },
      },
    })
  end,
}
,

	-- LSP setup dengan nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		"williamboman/mason-lspconfig.nvim",

		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lspconfig = require("lspconfig")
			local caps = vim.lsp.protocol.make_client_capabilities()
			caps.textDocument.completion.completionItem.snippetSupport = true
			caps = require("cmp_nvim_lsp").default_capabilities(caps)

			local on_attach = function(client, bufnr)
				local km = vim.api.nvim_buf_set_keymap
				local o  = { noremap = true, silent = true }

				km(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", o)
				km(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", o)
				km(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", o)
				km(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", o)
				km(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", o)
				km(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", o)
				km(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", o)
				km(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", o)
				km(bufnr, "n", "<leader>f", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", o)
			end

			local servers = {
				"bashls", "cssls", "lua_ls", "ts_ls",
				"superhtml", "tailwindcss", "vuels", "jsonls", "yamlls",
				"sqlls",  "jdtls", "vimls","sourcery", "ruff", "asm_lsp", "intelephense", "marksman"
			}
			for _, srv in ipairs(servers) do
				lspconfig[srv].setup({
					capabilities = caps,
					on_attach    = on_attach,
					flags        = { debounce_text_changes = 100 },
				})
			end


local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

lspconfig.marksman.setup({
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  }),

  on_attach = function(_, bufnr)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- 📚 Navigasi & bantuan
    map("n", "K", vim.lsp.buf.hover, "Hover Docs")
    map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
    map("n", "gr", vim.lsp.buf.references, "Show References")

    -- ✏️ Editing
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, "Format Document")

    -- 🧠 Informasi dokumen
    map("n", "<leader>di", vim.lsp.buf.document_symbol, "Document Symbols")
    map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols")

    -- 📑 Diagnostik
    map("n", "<leader>e", vim.diagnostic.open_float, "Show Line Diagnostic")
    map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
    map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
    map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostic List")
  end,
})

--------------------------------------------------------------
lspconfig.superhtml.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    html = {
      validate = {
        enable = true,
        scripts = true,
        styles = true,
        autoFix = true,
        validateElementClose = true,
        validateElementName = true,
        validateIndentation = true,
        validateSelfClosing = true,
        validateTagName = true,
        warnAboutInvalidHTML = true,
      },
      format = {
        enable = true,
        wrapLineLength = 120,
        unformatted = { "pre", "code" },
        defaultFormatter = "markuplint", -- Diganti ke Markuplint
        style = { ["markuplint/markuplint"] = true },
        script = { ["markuplint/markuplint"] = true },
        css = { ["markuplint/markuplint"] = true },
        inlineStyle = { ["markuplint/markuplint"] = true },
        inlineScript = { ["markuplint/markuplint"] = true },
      },
      suggest = {
        html5 = true,
        style = true,
        tag = true,
        css = true,
        script = true,
        json = true,
        yaml = true,
        markdown = true,
        sql = true,
        typescript = true,
        vue = true,
        attribute = true,
        event = true,
        semantic = true,
        jsonSchema = true,
        xml = true,
      },
      lint = {
        validate = true,
        maxLineLength = 80,
        htmlhint = { -- Integrasi HTMLHint untuk linting
          enable = true,
          config = {
            ["attr-value-double-quotes"] = true,
            ["tag-pair"] = true,
            ["id-unique"] = true,
            ["attr-lowercase"] = true,
            ["doctype-first"] = true,
          },
        },
      },
      completion = {
        enable = true,
        autoInsert = true,
        suggest = true,
        snippetSupport = true,
        matchOnInsert = true,
        autoTrigger = true,
        detailed = true,
        triggerCharacters = { "<", "/", ":", "." },
        autoCloseTags = { -- Fitur Auto-close Tags
          enable = true,
        },
      },
      css = {
        validate = true,
        lint = true,
        format = {
          enable = true,
          defaultFormatter = "prettier",
        },
      },
      javascript = {
        validate = true,
        format = {
          enable = true,
          defaultFormatter = "prettier",
        },
      },
      vue = {
        validate = true,
        format = {
          enable = true,
          defaultFormatter = "prettier",
        },
      },
      snippets = { -- Menambahkan Snippets HTML Bawaan
        enable = true,
        builtInSnippets = true,
        customSnippets = {
          ["html5-template"] = "<!DOCTYPE html>\n<html>\n<head>\n<title>${1:Document}</title>\n</head>\n<body>\n${2}\n</body>\n</html>",
        },
      },
      tailwindCSS = { -- Integrasi TailwindCSS IntelliSense
        validate = true,
        format = true,
        completion = true,
        lint = true,
      },
      semanticHighlighting = { -- Semantic Highlighting
        enable = true,
      },
      debug = {
        enable = true,
        logLevel = "debug",
        traceResponse = true,
        runInFile = true,
        runInTerminal = true,
        console = "integratedTerminal",
        source = "always",
        adapter = "test-adapter",
        internalConsoleOptions = "neverOpen",
        debuggerType = "integrated",
        traceServer = "verbose",
        workspaceFolder = true,
        traceFiles = {
          enable = true,
          level = "verbose",
        },
        integratedTerminal = {
          enable = true,
          startInBackground = true,
        },
      },
      api = {
        documentation = {
          enable = true,
          triggerOnHover = true,
        },
        mapping = {
          enable = true,
          trigger = "ctrl-space",
        },
      },
    },
  },
}


----

lspconfig.intelephense.setup({
  on_attach = function(client, bufnr)
    local function map(mode, lhs, rhs)
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
    end

    -- Keymaps LSP
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    map('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>')

    -- Auto-format on save
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end

    -- Tampilkan diagnostics saat hover
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
      end,
    })

    -- ESLint auto fix (jika terpasang ESLint plugin)
    if client.name == "eslint" and client.server_capabilities.codeActionProvider then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end
  end,

  on_init = function(client)
    print("[LSP] Intelephense initialized for " .. client.name)
  end,

  capabilities = require("cmp_nvim_lsp").default_capabilities(),

  settings = {
    intelephense = {
      phpVersion = "8.3.15",
      environment = {
        includePaths = { "./vendor" },
      },
      files = {
        maxSize = 5000000,
      },
      telemetry = { enabled = false },
      format = { enable = true },
      completion = {
        fullyQualifyGlobalConstantsAndFunctions = true,
        triggerParameterHints = true,
      },
      diagnostics = {
        enable = true,
        undefinedTypes = true,
        undefinedFunctions = true,
        undefinedConstants = true,
        undefinedVariables = true,
      },
      phpdoc = {
        enable = true,
      },
    },
  },

  root_dir = util.root_pattern(
    "composer.json",
    ".git"
  ),
})

require('lspconfig').tailwindcss.setup({
  filetypes = {
    "css", "scss", "sass", "html", "javascript", "typescript",
    "javascriptreact", "typescriptreact", "vue", "svelte",
    "astro", "react", "blade", "php", "mdx", "markdown"
  },

  on_attach = function(client, bufnr)
    local bufmap = function(mode, lhs, rhs)
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
    end

    -- ✨ Keymaps LSP Premium
    bufmap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
    bufmap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>')
    bufmap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
    bufmap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>')
    bufmap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
    bufmap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
    bufmap('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>')
    bufmap('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>')
    bufmap('n', '<leader>f', '<Cmd>lua vim.lsp.buf.format({ async = true })<CR>')
    bufmap('n', 'gh', '<Cmd>lua vim.lsp.buf.hover()<CR>')

    -- ✨ Format otomatis
    if client.server_capabilities.documentFormattingProvider then
      vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = false })]]
    end
  end,

  on_init = function(client)
    print("🎨 TailwindCSS LSP initialized — Design with power!")
  end,

  capabilities = require("cmp_nvim_lsp").default_capabilities(),

  flags = {
    debounce_text_changes = 100,
    allow_incremental_sync = true,
  },

  settings = {
    tailwindCSS = {
      validate = true,
      experimental = {
        classRegex = {
          -- Regex untuk berbagai framework
          { "tw`([^`]*)", 1 },
          { "tw=\"([^\"]*)", 1 },
          { "tw={\"([^\"]*)", 1 },
          { "tw\\.\\w+`([^`]*)", 1 },
          { "className=\"([^\"]*)", 1 },
          { "class=\"([^\"]*)", 1 },
          { "class:\\s*\"([^\"]*)", 1 },
        }
      },
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidScreen = "error",
        invalidVariant = "error",
        invalidConfigPath = "error",
        recommendedVariantOrder = "warning",
      },
      classAttributes = { "class", "className", "ngClass" },

      completion = {
        enable = true,
        suggestClassName = true,
        suggestClassKey = "class",
      },

      hover = {
        enable = true,
        showTailwindConfig = true,
        showExpandedClasses = true,
      },

      snippet = {
        enable = true,
        html = { enable = true },
        css = { enable = true },
        javascript = { enable = true },
        typescript = { enable = true },
        vue = { enable = true },
        react = { enable = true },
        svelte = { enable = true },
      },

      emmetCompletions = true,
      rootPattern = { ".git", "tailwind.config.js", "tailwind.config.ts", "postcss.config.js" },
    }
  },

  -- 🔍 Diagnostics setup

  handlers = {
    ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
      config = config or {}
      config.underline = true
      config.virtual_text = {
        spacing = 2,
        prefix = "●",
      }
      config.signs = true
      config.update_in_insert = true
      -- vim.diagnostic.handlers.default.publish_diagnostics(_, result, ctx, config)
    end,
  },

})

-- SUPERHTML CONFIG
lspconfig.superhtml.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    html = {
      validate = {
        enable = true,
        scripts = true,
        styles = true,
        autoFix = true,
        validateElementClose = true,
        validateElementName = true,
        validateIndentation = true,
        validateSelfClosing = true,
        validateTagName = true,
        warnAboutInvalidHTML = true,
      },
      format = {
        enable = true,
        wrapLineLength = 120,
        unformatted = { "pre", "code" },
        defaultFormatter = "markuplint",
        style = { ["markuplint/markuplint"] = true },
        script = { ["markuplint/markuplint"] = true },
        css = { ["markuplint/markuplint"] = true },
        inlineStyle = { ["markuplint/markuplint"] = true },
        inlineScript = { ["markuplint/markuplint"] = true },
      },
      suggest = {
        html5 = true,
        style = true,
        tag = true,
        css = true,
        script = true,
        json = true,
        yaml = true,
        markdown = true,
        sql = true,
        typescript = true,
        vue = true,
        attribute = true,
        event = true,
        semantic = true,
        jsonSchema = true,
        xml = true,
      },
      lint = {
        validate = true,
        maxLineLength = 80,
        htmlhint = {
          enable = true,
          config = {
            ["attr-value-double-quotes"] = true,
            ["tag-pair"] = true,
            ["id-unique"] = true,
            ["attr-lowercase"] = true,
            ["doctype-first"] = true,
          },
        },
      },
      completion = {
        enable = true,
        autoInsert = true,
        suggest = true,
        snippetSupport = true,
        matchOnInsert = true,
        autoTrigger = true,
        detailed = true,
        triggerCharacters = { "<", "/", ":", "." },
        autoCloseTags = {
          enable = true,
        },
      },
      css = {
        validate = true,
        lint = true,
        format = {
          enable = true,
          defaultFormatter = "prettier",
        },
      },
      javascript = {
        validate = true,
        format = {
          enable = true,
          defaultFormatter = "prettier",
        },
      },
      vue = {
        validate = true,
        format = {
          enable = true,
          defaultFormatter = "prettier",
        },
      },
      snippets = {
        enable = true,
        builtInSnippets = true,
        customSnippets = {
          ["html5-template"] = "<!DOCTYPE html>\n<html>\n<head>\n<title>${1:Document}</title>\n</head>\n<body>\n${2}\n</body>\n</html>",
        },
      },
      tailwindCSS = {
        validate = true,
        format = true,
        completion = true,
        lint = true,
      },
      semanticHighlighting = {
        enable = true,
      },
      debug = {
        enable = true,
        logLevel = "debug",
        traceResponse = true,
        runInFile = true,
        runInTerminal = true,
        console = "integratedTerminal",
        source = "always",
        adapter = "test-adapter",
        internalConsoleOptions = "neverOpen",
        debuggerType = "integrated",
        traceServer = "verbose",
        workspaceFolder = true,
        traceFiles = {
          enable = true,
          level = "verbose",
        },
        integratedTerminal = {
          enable = true,
          startInBackground = true,
        },
      },
      api = {
        documentation = {
          enable = true,
          triggerOnHover = true,
        },
        mapping = {
          enable = true,
          trigger = "ctrl-space",
        },
      },
    },
  },
}

lspconfig.ts_ls.setup {
  on_attach = on_attach,  -- Fungsi yang mengonfigurasi keybindings dan pengaturan lainnya
  capabilities = capabilities,  -- Kemampuan untuk mendukung autocompletion, dll.
  on_init = on_init,  -- Fungsi untuk menginisialisasi server
  settings = {
    javascript = {
      validate = true,
      format = {
        enable = true,
        defaultFormatter = "prettier",  -- Gunakan Prettier untuk format kode
        wrapLineLength = 120,  -- Panjang garis maksimal
      },
      suggest = {
        enable = true,
        autoImports = true,  -- Aktifkan auto-import
        includeCompletionsForModuleExports = true,  -- Saran untuk ekspor modul
        showDocumentation = true,  -- Tampilkan dokumentasi saat hover
        completeFunctionCalls = true,  -- Lengkapi panggilan fungsi secara otomatis
        includeCompletionsWithSnippetText = true,  -- Gunakan snippet saat memberikan saran
      },
      diagnostics = {
        enable = true,
        lint = {
          enable = true,  -- Aktifkan linting untuk JavaScript
          rule = "all",  -- Terapkan semua aturan linting
        },
      },
    },
    typescript = {
      validate = true,
      format = {
        enable = true,
        defaultFormatter = "prettier",  -- Gunakan Prettier untuk format kode
        wrapLineLength = 120,  -- Panjang garis maksimal
      },
      suggest = {
        enable = true,
        autoImports = true,  -- Aktifkan auto-import untuk TypeScript
        includeCompletionsForModuleExports = true,  -- Saran ekspor modul TypeScript
        completeFunctionCalls = true,  -- Lengkapi panggilan fungsi secara otomatis
        includeCompletionsWithSnippetText = true,  -- Gunakan snippet saat memberikan saran
      },
      diagnostics = {
        enable = true,
        lint = {
          enable = true,
          rule = "all",  -- Terapkan semua aturan linting di TypeScript
        },
      },
    },
    python = {
      enable = true,
      linting = {
        enable = true,
        pyflakes = true,  -- Gunakan Pyflakes untuk linting
        pylint = true,  -- Gunakan Pylint untuk linting
        flake8 = true,  -- Gunakan Flake8 untuk linting
      },
      formatting = {
        provider = "black",  -- Gunakan Black untuk format otomatis
      },
      diagnostics = {
        enable = true,
        lint = {
          enable = true,  -- Aktifkan linting di Python
        },
      },
      suggest = {
        enable = true,
        autoImports = true,  -- Aktifkan auto-import untuk Python
        completeFunctionCalls = true,  -- Lengkapi panggilan fungsi secara otomatis
      },
    },
    java = {
      enable = true,
      format = {
        enable = true,
        defaultFormatter = "google-java-format",  -- Gunakan Google Java Format untuk format otomatis
      },
      diagnostics = {
        enable = true,  -- Aktifkan diagnostik di Java
      },
      completion = {
        enable = true,
        autoInsert = true,  -- Auto-insert completions
        completeFunctionCalls = true,  -- Lengkapi panggilan fungsi secara otomatis
      },
      suggest = {
        enable = true,
        autoImports = true,  -- Aktifkan auto-import untuk Java
        includeCompletionsForModuleExports = true,  -- Saran ekspor modul Java
        completeFunctionCalls = true,  -- Lengkapi panggilan fungsi Java secara otomatis
      },
    },
  },

  -- Pengaturan untuk debugging di Neovim
  debug = {
    enable = true,
    logLevel = "debug",  -- Tingkat log debugging
    runInTerminal = true,  -- Jalankan debug di terminal
    console = "integratedTerminal",  -- Gunakan terminal terintegrasi
  },

  -- Penambahan fungsionalitas canggih seperti navigasi kode
  keymaps = {
    ["gd"] = vim.lsp.buf.definition,  -- Navigasi ke definisi
    ["gr"] = vim.lsp.buf.references,  -- Temukan referensi
    ["K"] = vim.lsp.buf.hover,  -- Tampilkan dokumentasi saat hover
    ["gi"] = vim.lsp.buf.implementation,  -- Navigasi ke implementasi
    ["<C-k>"] = vim.lsp.buf.signature_help,  -- Tampilkan bantuan tanda tangan
    -- ["<C-space>"] = vim.lsp.buf.completion,  -- Trigger completion secara manual
  },

  -- Pengaturan untuk auto-completion dan snippet
  completion = {
    enable = true,
    autocomplete = true,  -- Aktifkan autocomplete saat mengetik
    keyword_length = 1,  -- Saran muncul setelah 1 karakter
    snippetSupport = true,  -- Mendukung snippet
    triggerCharacters = { ".", ":", "(", "[" },  -- Karakter trigger untuk saran otomatis
    preselect = true,  -- Pilih item pertama dalam daftar saran secara otomatis
    maxItems = 20,  -- Batasi jumlah saran yang ditampilkan
    completeFunctionCalls = true,  -- Lengkapi panggilan fungsi secara otomatis
    showSignature = true,  -- Tampilkan signature fungsi saat menyelesaikan panggilan fungsi
    showDocumentation = true,  -- Tampilkan dokumentasi saat hover
  },

  -- Menambahkan integrasi dengan AI (misalnya menggunakan model AI untuk kode)
  ai_integration = {
    enable = true,
    python_ai = true,  -- Integrasi dengan AI menggunakan Python (misalnya untuk analisis kode)
    java_ai = true,  -- Integrasi dengan AI menggunakan Java (misalnya untuk optimasi atau prediksi kode)
    model = "gpt-3.5-turbo",  -- Pilih model AI yang digunakan
    endpoint = "http://localhost:5000",  -- URL endpoint untuk server AI (misalnya server lokal yang menjalankan model)
    code_suggestions = true,  -- Aktifkan saran kode berbasis AI
    code_refactoring = true,  -- Aktifkan refactoring kode berbasis AI
  },

  -- Pengaturan tambahan untuk meningkatkan produktivitas pengkodean
  linting = {
    enable = true,
    lint_on_save = true,  -- Lakukan linting otomatis saat file disimpan
    lint_on_type = true,  -- Lakukan linting otomatis saat mengetik
  },

  -- Refactoring otomatis dan fitur lainnya
  refactor = {
    enable = true,
    rename = true,  -- Aktifkan refactoring untuk merename variabel dan fungsi
    extract_method = true,  -- Aktifkan ekstraksi metode untuk refactoring
    extract_variable = true,  -- Aktifkan ekstraksi variabel untuk refactoring
  },
}

--------------------------------------------------------------
lspconfig.asm_lsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
  cmd = { "asm-lsp" },
  filetypes = { "asm", "s", "S" },
  root_dir = lspconfig.util.root_pattern("Makefile", ".git", "boot", "kernel", "linker.ld"),
  settings = {
    asm = {
      architecture = "x86_64",
      mode = "linux",
      diagnostics = {
        enabled = true,
        warnOnUnusedLabels = true,
        warnOnUndefinedSymbols = true,
        warnOnDeprecatedInstructions = true,
        warnOnUnalignedAccess = true,
        warnOnInvalidOpcode = true,
        showErrorCodes = true,
        showHints = true,
      },
      formatting = {
        enable = true,
        indentStyle = "space",
        indentSize = 2,
        trimTrailingWhitespace = true,
        formatOnSave = true,
        tabWidth = 2,
        alignLabels = true,
        alignComments = true,
      },
      linting = {
        enable = true,
        checkSyntaxOnly = false,
        styleRules = {
          enforceUppercaseOpcodes = true,
          requireCommentForSections = true,
        },
      },
      analysis = {
        enable = true,
        constantFolding = true,
        deadCodeDetection = true,
        unreachableCode = true,
        macroExpansion = true,
      },
      navigation = {
        goToDefinition = true,
        goToInclude = true,
        symbolOutline = true,
        showParameterHints = true,
      },
      hover = {
        showInstructionDocs = true,
        showRegisterInfo = true,
        showDirectivesHelp = true,
        showSyscallInfo = true, -- ⬅️ Tambahan untuk OS dev
      },
      completion = {
        enable = true,
        suggestLabels = true,
        suggestRegisters = true,
        suggestMnemonics = true,
        suggestMacros = true,
        suggestSyscalls = true, -- ⬅️ Tambahan: syscall autocomplete
        suggestInterrupts = true, -- ⬅️ Tambahan: INT/BIOS/UEFI
        libraryPaths = {
          "/usr/include", -- libc headers
          "/usr/include/sys", -- syscall headers
          "/usr/local/include",
          --"/path/to/your/os/lib/include", -- ⬅️ Tambahkan custom OS lib
        },
      },
      advanced = {
        highlightDirectives = true,
        highlightMacros = true,
        showInstructionHints = true,
        symbolIndexing = true,
        symbolRenaming = true,
      },
      experimental = {
        disassemblerIntegration = false,
        emulateInstructions = false
      }
    }
  }
}

--------------------------------------------------------------
require("lspconfig").ruff_lsp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    python = {
      analysis = {
        diagnosticMode = "workspace",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        typeCheckingMode = "strict",
        importStrategy = "fromEnvironment",
        importFormat = "relative",
        reportMissingImports = true,
        reportUnusedImport = true,
        reportUnusedClass = true,
        reportUnusedFunction = true,
        reportUnusedVariable = true,
        runtimeTypeChecking = true,
        stubPath = "./stubs",
        reportGeneralTypeIssues = true,
        reportUnusedSelf = true,
        reportUnusedFunctionArgs = true,
        reportUnusedLoopVars = true,
        reportUnusedLocals = true,
        reportUnusedAssignments = true,
        reportUnusedFunctionResults = true,
      },
      linting = {
        enabled = true,
        rules = {
          ["no-assert"] = "off",
          ["unused-imports"] = "off",
          ["too-many-locals"] = "off",
          ["complexity"] = "off",
          ["inconsistent-return-statements"] = "on",
          ["no-self-argument"] = "on",
          ["no-dupe-args"] = "on",
        },
        select = {
          "ALL",
        },
        ignore = {
          "C901",
        },
        extendSelect = {
          "I",
          "F",
          "E",
          "W",
          "D",
          "B",
          "PL",
          "PT",
          "NPY",
          "PD",
        },
        fixAll = true,
      },
      formatting = {
        enabled = true,
        provider = "black",
        lineLength = 120,
        allowMultipleLines = true,
        singleQuote = true,
      },
      workspace = {
        maxPreload = 2000,
        preloadModules = true,
        extraPaths = {
          "./src",
          "./lib",
          "./tests",
        },
      },
      pythonPath = "/usr/bin/python3.13",
      targetVersion = "py313",
    },
    lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
  filetypes = { "python", "jupyter", "ipynb" },
})

------------------------------------
lspconfig.sourcery.setup {
  on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '[d', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

    if client.server_capabilities.documentFormattingProvider then
      vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })]]
    end
  end,

  on_init = function(client)
    print("✅ Sourcery Ready!")
  end,

  capabilities = vim.lsp.protocol.make_client_capabilities(),

  settings = {
    sourcery = {
      lsp = {
        enabled = true,
        builtin = true,
        telemetry = {
          enabled = true,
          usageStats = true,
          performanceMetrics = true,
          errorReports = true,
          featureUsage = true,
        },
        interactive = true,
        explainCode = true,
        suggestCode = true,
        suggestLibraries = true,
        explainLibraries = true,
        codeInsights = true,
        documentationOnHover = true,
        autoFixIssues = true,
        semanticTokens = true,
        symbolSupport = true,
        hover = true,
        completion = true,
        codeActions = true,
        signatureHelp = true,
        documentSymbols = true,
        foldingRange = true,
        documentHighlight = true,
        references = true,
        rename = true,
        inlayHints = true,
      },
      python = {
        analysis = {
          typeCheckingMode = "strict",
          autoImportCompletions = true,
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
          extraPaths = { "./", "./src", "./venv/lib/python3.*/site-packages" },
        },
      },

      documentation = {
        showLibraryDocs = true,
        fetchExamples = true,
        explainFunctions = true,
        showSourceLink = true,
        showCode = true,
        showRelatedSnippets = true, -- Tambahan: contoh-contoh kode lain
      },

      linting = {
        enabled = true,
        pylintEnabled = true,
        flake8Enabled = true,
        mypyEnabled = true,
        banditEnabled = true,
        maxLineLength = 120,
      },

      formatting = {
        provider = "black",
        blackPath = "black",
        autoFormatOnSave = true,
      },

      refactor = {
        extractMethod = true,
        extractVariable = true,
        organizeImports = true,
        inlineVariable = true,
        renameSymbol = true,
        smartRefactorAI = true, -- Tambahan AI Refactoring
      },

      docStringGeneration = true,
      explain = true,

      importResolver = {
        autoFixMissing = true,
        autoOrganize = true,
      },

      codeQuality = {
        suggestImprovements = true,
        analyzeComplexity = true,
        detectDeadCode = true,
        detectInefficientPatterns = true,
        inlineCommentsAI = true,
        maxLineLength = 120,
        maxMethodLength = 120,
        maxParameterListLength = 120,
        maxParameters = 120,
      },

      productivity = {
        taskTracking = true,
        focusMode = true,
        todoHighlight = true,
        deadlineReminder = true,
      },

      personalization = {
        preferredLanguage = "id", -- jika ingin pakai bahasa Indonesia
        tone = "friendly", -- gaya output AI
      },

      learningAssistant = {
        enableMentorMode = true,
        highlightConcepts = true,
        autoSuggestDocs = true,
        challengeSuggestions = true,
        interactiveQuizzes = true,
        explainErrors = true,
        stepByStepGuides = true,
        adaptiveLearningPath = true,

      },
    },
  },



      productivity = {
        taskTracking = true,
        focusMode = true,
        todoHighlight = true,
        deadlineReminder = true,
        smartNotifications = true,
        flowMode = true,
      },

      personalization = {
        preferredLanguage = "id",
        tone = "friendly",
        interfaceTheme = "dark",
        voiceAssistant = true,
        accessibilitySupport = true,
      },

      writingAssistant = {
        grammarSuggestions = true,
        toneAnalysis = true,
        rewriteSuggestions = true,
        plagiarismCheck = true,
        generateHeadings = true,
        summarizeText = true,
        expandSentences = true,
      },

  hooks = {
    before_command = function(command)
      print("🚀 Executing Maven command:", command)
    end,
    after_command = function(command, result)
      print("✅ Maven command completed:", command, "Result:", result)
    end,
  },

  init_options = {
    token = "user_yW5OlJEHns66q_Rrkw_zFPyOid1x3HDkpDjozB98S6skRcwEg_uQAB2WHrc",
  },
}

local lspconfig = require("lspconfig")
local util = lspconfig.util

-- Enhanced capabilities for nvim-cmp and signature help
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.signatureHelp = { dynamicRegistration = true }

-- JDTLS setup
lspconfig.jdtls.setup({
  cmd = { "jdtls" }, -- ensure jdtls is in your PATH
  root_dir = util.root_pattern(".git", "pom.xml", "build.gradle", "mvnw", "gradlew"),
  capabilities = capabilities,

  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    -- Basic LSP mappings
    keymap(bufnr, "n", "K",       "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    keymap(bufnr, "n", "gd",      "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    keymap(bufnr, "n", "gi",      "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    keymap(bufnr, "n", "gr",      "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    keymap(bufnr, "n", "<C-k>",  "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    keymap(bufnr, "n", "<leader>f",  "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)
    keymap(bufnr, "i", "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>", opts)

    -- jdtls-specific refactor & organize imports
    keymap(bufnr, "n", "<leader>oi", "<Cmd>lua require('jdtls').organize_imports()<CR>", opts)
    keymap(bufnr, "n", "<leader>ev", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
    keymap(bufnr, "v", "<leader>em", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)

    -- Auto refresh code lens for run/test links
    if client.server_capabilities.codeLensProvider then
      vim.cmd([[
        augroup jdtls_lens_refresh
          autocmd! * <buffer>
          autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
        augroup END
      ]])
    end
  end,

  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },

      format = {
        enabled = true,
        settings = {
          url = "file://" .. os.getenv("HOME") .. "/.config/nvim/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },

      completion = {
        enabled = true,
        guessMethodArguments = true,
        filteredTypes = {},
        favoriteStaticMembers = {
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
        },
        importOrder = { "java", "javax", "com", "org" },
      },

      sources = { organizeImports = true },

      codeGeneration = { toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" }, useBlocks = true },
      saveActions   = { organizeImports = true },

      eclipse = { downloadSources = true },
      maven   = { downloadSources = true, downloadJavadoc = true, offline = false },

      referencesCodeLens      = { enabled = true },
      implementationsCodeLens = { enabled = true },

      inlayHints = {
        parameterNames    = { enabled = "all" },
        variableTypes     = { enabled = true },
        methodReturnTypes = { enabled = true },
      },

      autobuild = { enabled = true },

      -- AI-powered diagnostics & suggestions
      diagnostics = {
        enabled            = true,
        errorSeverity      = "ERROR",
        warningSeverity    = "WARNING",
        infoSeverity       = "INFO",
        suggestionSeverity = "HINT",
      },

      configuration = {
        runtimes = {
          { name = "JavaSE-24", path = "/usr/lib/jvm/java-24-openjdk/" },
          { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk/" },
          { name = "JavaSE-11", path = "/usr/lib/jvm/java-11-openjdk/" },
          { name = "JavaSE-1.8", path = "/usr/lib/jvm/java-8-openjdk/" },
          { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk/" },

        },
      },
    },
  },
})

-- Auto organize imports on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.java",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local results = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
    for _, res in pairs(results or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit)
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end,
})

-- nvim-cmp setup with snippet, buffer, path sources
local cmp = require('cmp')
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>']   = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),
})




			--------------



		end,
	},
}
