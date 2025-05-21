return{
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.sql_formatter,
          null_ls.builtins.diagnostics.sqlfluff.with({
            extra_args = { "--dialect", "mysql" },
          }),
        },
      }
    end
  }

