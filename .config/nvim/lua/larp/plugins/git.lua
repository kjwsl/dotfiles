return {
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>cg', '<cmd>LazyGit<cr>', noremap = true, silent = true, desc = 'LazyGit' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  },
  {
    'sindrets/diffview.nvim',
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      'ibhagwan/fzf-lua', -- optional
    },
    config = function()
      require('neogit').setup({})
    end,
  },
}
