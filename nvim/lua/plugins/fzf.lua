return {
  "ibhagwan/fzf-lua",
  config = function()
    require('fzf-lua').setup({
      winopts = {
        preview = {
          default = "bat",
        },
      },
      fzf_opts = {
        ['--preview-window'] = 'up:50%:wrap',
      },
    })
  end,
}
