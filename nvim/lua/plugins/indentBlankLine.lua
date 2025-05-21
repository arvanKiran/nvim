return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = function()
    -- Definisi warna Rainbow secara manual
    local hl = vim.api.nvim_set_hl
    hl(0, "RainbowRed",    { fg = "#E06C75" })
    hl(0, "RainbowYellow", { fg = "#E5C07B" })
    hl(0, "RainbowBlue",   { fg = "#61AFEF" })
    hl(0, "RainbowOrange", { fg = "#D19A66" })
    hl(0, "RainbowGreen",  { fg = "#98C379" })
    hl(0, "RainbowViolet", { fg = "#C678DD" })
    hl(0, "RainbowCyan",   { fg = "#56B6C2" })

    return {
      indent = {
        char = "╎",
        tab_char = "╎",
        smart_indent_cap = true,
      },
      whitespace = {
        remove_blankline_trail = true,
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
        injected_languages = true,
        highlight = {
          "RainbowRed",
          "RainbowYellow",
          "RainbowBlue",
          "RainbowOrange",
          "RainbowGreen",
          "RainbowViolet",
          "RainbowCyan",
        },
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "lazy",
          "NvimTree",
          "Trouble",
          "markdown",
          "lspinfo",
          "packer",
        },
        buftypes = { "terminal", "nofile", "quickfix" },
      },
    }
  end,
}

