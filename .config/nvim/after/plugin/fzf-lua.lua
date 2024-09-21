local config_path = vim.fn.stdpath('config')

-- # Config
larp.fn.map('', '<leader>hfc', '<cmd>FzfLua files cwd=' .. config_path .. '<cr>', { silent = true, desc = 'Find Config Directory' })
larp.fn.map('', '<leader>hgc', '<cmd>FzfLua live_grep cwd=' .. config_path .. '<cr>', { silent = true, desc = 'Grep Config' })

-- # Basic
larp.fn.map('', '<leader>ff', '<cmd>FzfLua files<cr>', { silent = true, desc = 'Find Files' })
larp.fn.map('', '<leader>fo', '<cmd>FzfLua oldfiles<cr>', { silent = true, desc = 'Find Old Files' })
larp.fn.map('', '<leader>fq', '<cmd>FzfLua quickfix<cr>', { silent = true, desc = 'Quickfix List' })
larp.fn.map('', '<leader>fb', '<cmd>FzfLua buffers<cr>', { silent = true, desc = 'Find Buffers' })
larp.fn.map('', '<leader>gg', '<cmd>FzfLua live_grep<cr>', { silent = true, desc = 'Grep Current Directory' })
larp.fn.map('', '<leader>gb', '<cmd>FzfLua lgrep_curbuf<cr>', { silent = true, desc = 'Grep Inside Current Buffer' })
larp.fn.map('', '<leader>f:', '<cmd>FzfLua commands<cr>', { silent = true, desc = 'Find Commands' })
larp.fn.map('', '<leader>fj', '<cmd>FzfLua jumps<cr>', { silent = true, desc = 'Find Jumps' })
larp.fn.map('', '<leader>fxm', '<cmd>FzfLua marks<cr>', { silent = true, desc = 'Find Marks' })

-- # LSP
larp.fn.map('', 'gH', '<cmd>FzfLua lsp_document_diagnostics<cr>', { silent = true, desc = 'Find Diagnostics' })
larp.fn.map('', '<leader>f*', '<cmd>FzfLua lsp_finder<cr>', { silent = true, desc = 'Grep Symbols (LSP)' })
larp.fn.map('', '<leader>ft', '<cmd>FzfLua lsp_typedefs<cr>', { silent = true, desc = 'Find Typedefs' })
larp.fn.map('', '<leader>fsd', '<cmd>FzfLua lsp_document_symbols<cr>', { silent = true, desc = 'Find Document Symbols' })
larp.fn.map('', '<leader>fsw', '<cmd>FzfLua lsp_workspace_symbols<cr>', { silent = true, desc = 'Find Workspace Symbols' })
larp.fn.map('', '<leader>fd', '<cmd>FzfLua lsp_definitions<cr>', { silent = true, desc = 'Find Definitions' })
larp.fn.map('', '<leader>fD', '<cmd>FzfLua lsp_declarations<cr>', { silent = true, desc = 'Find Declarations' })
larp.fn.map('', '<leader>ca', '<cmd>FzfLua lsp_code_actions<cr>', { silent = true, desc = 'Code Actions' })
larp.fn.map('', '<leader>fxic', '<cmd>FzfLua lsp_incoming_calls<cr>', { silent = true, desc = 'Find Incoming Calls' })
larp.fn.map('', '<leader>fxoc', '<cmd>FzfLua lsp_outgoing_calls<cr>', { silent = true, desc = 'Find Outgoing Calls' })

-- Misc.
larp.fn.map('', '<leader>fgc', '<cmd>FzfLua git_commits<cr>', { silent = true, desc = 'Find Git Commits' })
larp.fn.map('', '<leader>fgf', '<cmd>FzfLua git_files<cr>', { silent = true, desc = 'Find Git Files' })
larp.fn.map('', '<leader>fh', '<cmd>FzfLua helptags<cr>', { silent = true, desc = 'Find Helptags' })
larp.fn.map('', '<leader>fk', '<cmd>FzfLua keymaps<cr>', { silent = true, desc = 'Find Keymaps' })
larp.fn.map('', '<leader>fm', '<cmd>FzfLua manpages<cr>', { silent = true, desc = 'Find Manpages' })
larp.fn.map('', '<leader>fr', '<cmd>FzfLua resume<cr>', { silent = true, desc = 'Resume Search' })
larp.fn.map('', '<leader>fxa', '<cmd>FzfLua autocmds<cr>', { silent = true, desc = 'Find Manpages' })
larp.fn.map('', '<leader>fxc', '<cmd>FzfLua changes<cr>', { silent = true, desc = 'Find Changes' })
larp.fn.map('', '<leader>fxr', '<cmd>FzfLua registers<cr>', { silent = true, desc = 'Find Registers' })
larp.fn.map('', '<leader>fxt', '<cmd>FzfLua colorschemes<cr>', { silent = true, desc = 'Find Themes' })

-- # Grep
larp.fn.map('', '<leader>gC', '<cmd>FzfLua grep_cWORD<cr>', { silent = true, desc = 'Grep Cursor (Case Sensitive)' })
larp.fn.map('', '<leader>gc', '<cmd>FzfLua grep_cword<cr>', { silent = true, desc = 'Grep Cursor (Case Insensitive)' })
larp.fn.map('', '<leader>gv', '<cmd>FzfLua grep_visual<cr>', { silent = true, desc = 'Grep Selection' })
