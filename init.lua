-- Bootstrap lazy
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- This has to be set before initializing lazy
vim.g.mapleader = " "


-- Initialize lazy with dynamic loading of anything in the plugins directory
require("lazy").setup("plugins", {
   change_detection = {
    enabled = true, -- automatically check for config file changes and reload the ui
    notify = false, -- turn off notifications whenever plugin changes are made
  },
})
-- Load VSCode keymaps if running in VSCode
if vim.g.vscode then
  -- VSCode extension
  local vscode = require("vscode-neovim")

  vim.api.nvim_set_hl(0, "LeapTarget", { fg = "Orange", bg = "DarkBlue", bold = true })
  vim.api.nvim_set_hl(0, "LeapCharacter", { fg = "Yellow", bg = "DarkRed", bold = true })

  -- Key mappings
  local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
      options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
  end

  map("n", "gr", function() vscode.call("editor.action.goToReferences") end)

  -- Normal mode mappings
  map("n", "gp", function() vscode.call("editor.action.triggerParameterHints") end, { silent = true })
  map("n", "R", function() vscode.call("editor.action.rename") end, { silent = true })
  map("n", "<C-n>", ":nohl<CR>", { silent = true })

  -- Tab management
  map("n", "th", ":tabp<CR>", { silent = true })
  map("n", "tl", ":tabn<CR>", { silent = true })

  -- Switch between editor groups
  map("n", "tH", function() vscode.call("workbench.action.focusLeftGroup") end, { silent = true })
  map("n", "tL", function() vscode.call("workbench.action.focusRightGroup") end, { silent = true })
  map("n", "tK", function() vscode.call("workbench.action.focusAboveGroup") end, { silent = true })
  map("n", "tJ", function() vscode.call("workbench.action.focusBelowGroup") end, { silent = true })

  -- Leader key mappings
  map("n", "<leader>s", "<leader><leader>s", { remap = true })
  map("n", "<leader>e", "<leader><leader>e", { remap = true })
  map("n", "<leader>w", "<leader><leader>w", { remap = true })
  map("n", "<leader>l", "<leader><leader>l", { remap = true })

  map("v", ">", ":<C-u>execute 'editor.action.indentLines'<CR>", { silent = true })
  map("v", "<", ":<C-u>execute 'editor.action.outdentLines'<CR>", { silent = true })

else
 -- These modules are not loaded by lazy
  --
  require("core.options")
 -- LSP setup
  require('lspconfig').setup()

  
  -- Other plugins not needed in VSCode
  require('treesitter').setup()
  require('telescope').setup()
  -- ... other configurations require("core.keymaps")

  -- Enable system clipboard
  vim.opq.clipboard = "unnamedplus"

  -- Incremental search and highlight search
  vim.opt.incsearch = true
  vim.opt.hlsearch = true

  -- Enable Leap.nvim (EasyMotion alternative)
  require('leap').add_default_mappings()

  -- Use Ctrl-based movements in insert mode (already default in Neovim)
  vim.opt.ttimeoutlen = 50  -- Reduce delay for key sequences like <C-o>

  -- jj to exit insert mode
  vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true })

  -- Insert mode: <C-o> to create a new line and enter insert mode
  vim.api.nvim_set_keymap("i", "<C-o>", "<Esc>o", { noremap = true, silent = true })

  -- Normal mode keybindings (non-recursive)
  local keymap = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }

  -- Go to references (VSCode equivalent)
  keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

  -- Trigger parameter hints (LSP)
  keymap("n", "gp", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

  -- Rename symbol
  keymap("n", "R", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

  -- Clear search highlights
  keymap("n", "<C-n>", ":nohlsearch<CR>", opts)

  -- Tab navigation
  --
  keymap("n", "th", ":tabprevious<CR>", opts)
  keymap("n", "tl", ":tabnext<CR>", opts)

  -- Window (editor group) navigation
  keymap("n", "tH", "<C-w>h", opts)  -- Move to the left window
  keymap("n", "tL", "<C-w>l", opts)  -- Move to the right window
  keymap("n", "tK", "<C-w>k", opts)  -- Move to the upper window
  keymap("n", "tJ", "<C-w>j", opts)  -- Move to the lower window

  -- Visual mode keybindings
  keymap("v", ">", ">gv", opts)  -- Indent and stay in visual mode
  keymap("v", "<", "<gv", opts)  -- Outdent and stay in visual mode
end
