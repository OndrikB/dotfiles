--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {desc = "Directory listing (netrw)"})


vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
-- TODO: this requires ripgrep! Install it!
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<C-n>', ":NvimTreeToggle<CR>")
vim.keymap.set('n', '<C-b>', require('nvim-tree.api').tree.change_root_to_node, { desc = 'Change to selected directory'})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = '[E]rrors'})
-- LSP settings
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {desc = 'LSP: [R]e[n]ame'})
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {desc = 'LSP: [C]ode [A]ction'})
-- learn this please
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {desc = 'LSP: [G]oto [D]efinition'})
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {desc = 'LSP: [G]oto [R]eferences'})
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, {desc = 'LSP: [G]oto [I]mplementation'})

vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'LSP: Type [D]efinition'})
vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { desc = 'LSP: [D]ocument [S]ymbols'})
vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = 'LSP: [W]orkspace [S]ymbols'})

-- See `:help K` for why this keymap
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP: Hover Documentation'})
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'LSP: Signature Documentation'})

-- Lesser used LSP functionality
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP: [G]oto [D]eclaration'})
vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'LSP: [W]orkspace [A]dd Folder'})
vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'LSP: [W]orkspace [R]emove Folder'})
vim.keymap.set('n', '<leader>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = 'LSP: [W]orkspace [L]ist Folders'})
