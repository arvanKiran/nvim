return{
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter", -- plugin aktif saat mulai mengetik
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        next_suggestion = "<C-n>",
        prev_suggestion = "<C-p>",
      },
      enable_dependency_autocomplete = true,
      enable_task_runner = true,
    })
  end,
}

