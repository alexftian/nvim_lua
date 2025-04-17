return {
  "abecodes/tabout.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  cond = true, -- Enable in both regular Neovim and VSCode
  config = function()
    require("tabout").setup({
      tabkey = "<Tab>",
      backwards_tabkey = "<S-Tab>",
      act_as_tab = true,
      act_as_shift_tab = false,
      enable_backward = true,
      completion = true,
      tabouts = {
        {open = "'", close = "'"},
        {open = '"', close = '"'},
        {open = '`', close = '`'},
        {open = '(', close = ')'},
        {open = '[', close = ']'},
        {open = '{', close = '}'},
      },
      ignore_beginning = true,
      exclude = {},
    })
  end,
}