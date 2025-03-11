vim.api.nvim_create_autocmd({'InsertLeave'}, {
  pattern = '*',
  callback = function()
    vim.defer_fn(
      function()
        if vim.api.nvim_get_option_value('buftype', {buf = 0}) == '' then
          local current_view = vim.fn.winsaveview()
--          vim.cmd([[keeppatterns %s/\s\+$//e]])
          vim.fn.winrestview(current_view)
          vim.cmd('silent update')
        end
      end, 10
    )
  end
})
vim.api.nvim_create_autocmd({'TextChanged'}, {
  pattern = '*',
  callback = function()
    vim.defer_fn(
      function()
        if vim.api.nvim_get_option_value('buftype', {buf = 0}) == '' then
          vim.cmd('silent update')
        end
      end, 10
    )
  end
})

