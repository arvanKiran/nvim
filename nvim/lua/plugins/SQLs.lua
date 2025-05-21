 return {
    'nanotee/sqls',
    lazy = false,
    config = function()
      require('lspconfig').sqls.setup {
        settings = {
          sqls = {
            connections = {
              {
                driver   = 'mysql',
                datasourceName = 'god@tcp(127.0.0.1:3306)/rumahsakit',
              },
            },
          },
        },
      }
    end
  }
