return {
  "Everblush/nvim", -- Repo resmi
  name = "everblush",
  lazy = false,
  priority = 1000,
  config = function()
    -- Aktifkan true color
    vim.opt.termguicolors = true

    -- Terapkan tema everblush
    vim.cmd("colorscheme everblush")

    -- Transparansi background utama
    local transparent_groups = {
      "Normal", "NormalNC", "NormalFloat", "FloatBorder", "TelescopeNormal",
      "TelescopeBorder", "TelescopePromptNormal", "TelescopePromptBorder",
      "TelescopeResultsNormal", "TelescopeResultsBorder",
      "WhichKeyFloat", "StatusLine", "VertSplit"
    }

    for _, group in ipairs(transparent_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end

    -- Warna untuk syntax highlighting
    vim.api.nvim_set_hl(0, "Function", { fg = "#C3E88D", italic = true })
    vim.api.nvim_set_hl(0, "Keyword", { fg = "#C792EA", italic = true })
    vim.api.nvim_set_hl(0, "String", { fg = "#e6e6fa" })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#5C6370", italic = true })
    vim.api.nvim_set_hl(0, "Variable", { fg = "#F07178" })
    vim.api.nvim_set_hl(0, "Type", { fg = "#82AAFF", italic = true })
    vim.api.nvim_set_hl(0, "Number", { fg = "#FF5370" })
    vim.api.nvim_set_hl(0, "Boolean", { fg = "#FFCB6B" })
  end,
}

