-- Bootstrap lazy
vim.g.mapleader = " "
vim.keymap.set({"n", "v"}, "<Space>", "<Nop>", { silent = true })

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
vim.g.maplocalleader = " "
-- Disable the default space behavior
vim.keymap.set({"n", "v"}, "<Space>", "<Nop>", { silent = true })


-- Initialize lazy with dynamic loading of filtered plugins based on environment
if vim.g.vscode then
  -- In VSCode, only load leap and treesitter plugins
  require("lazy").setup({
  { "windwp/nvim-autopairs" },
  { "kylechui/nvim-surround" },
  { "tpope/vim-commentary" },
  { "szw/vim-maximizer" },
  { "echasnovski/mini.ai" },
  { "lukas-reineke/indent-blankline.nvim" },
  { 
    "ThePrimeagen/harpoon",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}, {
    change_detection = {
      enabled = true,
      notify = false,
    },
  })
else
  -- In regular Neovim, load all plugins
  require("lazy").setup("plugins", {
    change_detection = {
      enabled = true, -- automatically check for config file changes and reload the ui
      notify = false, -- turn off notifications whenever plugin changes are made
    },
  })
end
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

  -- Vim-maximizer
  map("n", "<leader>sm", function() vscode.call("workbench.action.toggleMaximizeEditorGroup") end, { silent = true })
  map("n", "<leader>sM", function() vscode.call("workbench.action.toggleMaximizeEditorGroup") end, { silent = true })

  -- Split window management
  map("n", "<leader>sv", function() vscode.call("workbench.action.splitEditorRight") end, { silent = true })
  map("n", "<leader>sh", function() vscode.call("workbench.action.splitEditorDown") end, { silent = true })
  map("n", "<leader>se", function() vscode.call("workbench.action.evenEditorWidths") end, { silent = true })
  map("n", "<leader>sx", function() vscode.call("workbench.action.closeActiveEditor") end, { silent = true })
  map("n", "<leader>sj", function() vscode.call("workbench.action.decreaseViewHeight") end, { silent = true })
  map("n", "<leader>sk", function() vscode.call("workbench.action.increaseViewHeight") end, { silent = true })
  map("n", "<leader>sl", function() vscode.call("workbench.action.increaseViewWidth") end, { silent = true })

  -- Tab management
  map("n", "<leader>tx", function() vscode.call("workbench.action.closeActiveEditor") end, { silent = true })
  map("n", "<leader>tg", function() vscode.call("workbench.action.splitEditor") end, { silent = true })
  map("n", "<leader>tn", function() vscode.call("workbench.action.nextEditor") end, { silent = true })
  map("n", "<leader>tp", function() vscode.call("workbench.action.previousEditor") end, { silent = true })

  -- Map '>' in visual mode to indent lines
  map('v', '>', function()  vscode.call('editor.action.indentLines') end, { silent = true })
  
  -- Map '<' in visual mode to outdent lines  
  map('v', '<', function() vscode.call('editor.action.outdentLines') end, { silent = true })

else
 -- These modules are not loaded by lazy
  --
  require("core.options")

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

  -- Rename symbol
  keymap("n", "R", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

  -- Clear search highlights
  keymap("n", "<C-n>", ":nohlsearch<CR>", opts)

  -- Tab navigation
  --
  keymap("n", "th", ":tabprevious<CR>", opts)
  keymap("n", "tl", ":tabnext<CR>", opts)

  -- Visual mode keybindings
  keymap("v", ">", ">gv", opts)  -- Indent and stay in visual mode
  keymap("v", "<", "<gv", opts)  -- Outdent and stay in visual mode

  -- Split window management
  keymap("n", "<leader>sv", "<C-w>v", opts) -- split window vertically
  keymap("n", "<leader>sh", "<C-w>s", opts) -- split window horizontally
  keymap("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width
  keymap("n", "<leader>sx", ":close<CR>", opts) -- close split window
  keymap("n", "<leader>sj", "<C-w>-", opts) -- make split window height shorter
  keymap("n", "<leader>sk", "<C-w>+", opts) -- make split windows height taller
  keymap("n", "<leader>sl", "<C-w>>5", opts) -- make split windows width bigger 
  keymap("n", "<leader>sh", "<C-w><5", opts) -- make split windows width smaller

  -- Tab management
  keymap("n", "<leader>to", ":tabnew<CR>", opts) -- open a new tab
  keymap("n", "<leader>tx", ":tabclose<CR>", opts) -- close a tab
  keymap("n", "<leader>tn", ":tabn<CR>", opts) -- next tab
  keymap("n", "<leader>tp", ":tabp<CR>", opts) -- previous tab

  -- Quickfix keymaps
  keymap("n", "<leader>qo", ":copen<CR>", opts) -- open quickfix list
  keymap("n", "<leader>qf", ":cfirst<CR>", opts) -- jump to first quickfix list item
  keymap("n", "<leader>qn", ":cnext<CR>", opts) -- jump to next quickfix list item
  keymap("n", "<leader>qp", ":cprev<CR>", opts) -- jump to prev quickfix list item
  keymap("n", "<leader>ql", ":clast<CR>", opts) -- jump to last quickfix list item
  keymap("n", "<leader>qc", ":cclose<CR>", opts) -- close quickfix list

  -- Vim-maximizer
  keymap("n", "<leader>sm", ":MaximizerToggle<CR>", opts) -- toggle maximize tab
  keymap("n", "<leader>sM", ":MaximizerToggle!<CR>", opts) -- toggle maximize tab

  -- Nvim-tree
  keymap("n", "<leader>ee", ":NvimTreeToggle<CR>", opts) -- toggle file explore, optsr
  keymap("n", "<leader>er", ":NvimTreeFocus<CR>", opts) -- toggle focus to file explore, optsr
  keymap("n", "<leader>ef", ":NvimTreeFindFile<CR>", opts) -- find file in file explore, optsr

  -- Telescope
  keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<CR>", opts) -- fuzzy find files in project
  keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", opts) -- grep file contents in project
  keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", opts) -- fuzzy find open buffers
  keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<CR>", opts) -- fuzzy find help tags
  keymap('n', '<leader>fs', "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", opts) -- fuzzy find in current file buffer
  keymap('n', '<leader>fo', "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", opts) -- fuzzy find LSP/class symbols
  keymap('n', '<leader>fi', "<cmd>lua require('telescope.builtin').lsp_incoming_calls()<CR>", opts) -- fuzzy find LSP/incoming calls
  -- keymap.set('n', '<leader>fm', function() require('telescope.builtin').treesitter({default_text=":method:"}) end) -- fuzzy find methods in current class
  keymap('n', '<leader>fm', "<cmd>lua require('telescope.builtin').treesitter({symbols={'function', 'method'}})<CR>", opts) -- fuzzy find methods in current class
  keymap('n', '<leader>ft', [[<cmd>lua 
    local success, node = pcall(function() return require('nvim-tree.lib').get_node_at_cursor() end)
    if not success or not node then return end;
    require('telescope.builtin').live_grep({search_dirs = {node.absolute_path}})
  <CR>]], opts) -- grep file contents in current nvim-tree node

  -- Harpoon
  keymap("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<CR>", opts)
  keymap("n", "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)
  keymap("n", "<leader>h1", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", opts)
  keymap("n", "<leader>h2", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", opts)
  keymap("n", "<leader>h3", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", opts)
  keymap("n", "<leader>h4", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", opts)
  keymap("n", "<leader>h5", "<cmd>lua require('harpoon.ui').nav_file(5)<CR>", opts)
  keymap("n", "<leader>h6", "<cmd>lua require('harpoon.ui').nav_file(6)<CR>", opts)
  keymap("n", "<leader>h7", "<cmd>lua require('harpoon.ui').nav_file(7)<CR>", opts)
  keymap("n", "<leader>h8", "<cmd>lua require('harpoon.ui').nav_file(8)<CR>", opts)
  keymap("n", "<leader>h9", "<cmd>lua require('harpoon.ui').nav_file(9)<CR>", opts)

  -- Vim REST Console
  keymap("n", "<leader>xr", ":call VrcQuery()<CR>", opts) -- Run REST query

  -- LSP
  keymap('n', '<leader>gg', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  keymap('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  keymap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  keymap('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  keymap('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  keymap('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  keymap('n', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>', opts)
  keymap('v', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>', opts)
  keymap('n', '<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  keymap('n', '<leader>gl', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  keymap('n', '<leader>gp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  keymap('n', '<leader>gn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  keymap('n', '<leader>tr', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  keymap('i', '<C-Space>', '<cmd>lua vim.lsp.buf.completion()<CR>', opts)
  -- Debugging
  keymap("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
  keymap("n", "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", opts)
  keymap("n", "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", opts)
  keymap("n", '<leader>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>", opts)
  keymap("n", '<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>', opts)
  keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
  keymap("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>", opts)
  keymap("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>", opts)
  keymap("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>", opts)
  keymap("n", '<leader>dd', "<cmd>lua require('dap').disconnect(); require('dapui').close()<CR>", opts)
  keymap("n", '<leader>dt', "<cmd>lua require('dap').terminate(); require('dapui').close()<CR>", opts)
  keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
  keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
  keymap("n", '<leader>di', "<cmd>lua require('dap.ui.widgets').hover()<CR>", opts)
  keymap("n", '<leader>d?', "<cmd>lua local widgets = require('dap.ui.widgets'); widgets.centered_float(widgets.scopes)<CR>", opts)
  keymap("n", '<leader>df', '<cmd>Telescope dap frames<cr>', opts)
  keymap("n", '<leader>dh', '<cmd>Telescope dap commands<cr>', opts)
  keymap("n", '<leader>de', "<cmd>lua require('telescope.builtin').diagnostics({default_text=':E:'})<CR>", opts)
end
