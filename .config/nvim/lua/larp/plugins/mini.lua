return {
  -- # Provides various useful modules
  'echasnovski/mini.nvim',
  version = '*',
  config = function()
    -- mini.align is a module that aligns text in visual mode
    require('mini.align').setup({})

    -- mini.ai is a module that provides more text objects, especially for ones that start with `a(round)`, and `i(nside)`
    -- Check out the documentation for more information (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md)
    -- require('mini.ai').setup({})
    require('mini.move').setup({
      mappings = {
        -- In Visual Mode
        left = 'H',
        right = 'L',
        down = 'J',
        up = 'K',

        -- In Normal Mode
        line_left = '<M-s-h>',
        line_right = '<M-s-l>',
        line_down = '<M-s-j>',
        line_up = '<M-s-k>',
      },
    })
  end,
}
