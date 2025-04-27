local function set_word_color()
  vim.api.nvim_set_hl(0, 'WordUnderCursor', {
    bold     = true,
    fg       = '#ffffff',
    bg       = '#005fdd',
    ctermfg  = 'white',
    ctermbg  = 'Blue',
  })
end

set_word_color()
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern  = '*',
  callback = set_word_color,
})

local ns_id = vim.api.nvim_create_namespace('WordUnderCursor')

function _G.toggle_highlight_word()
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

  if vim.b.word_highlight_active then
    vim.b.word_highlight_active = nil
    return
  end

  local word = vim.fn.expand('<cword>')
  if word == '' then return end

  local lines   = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local pattern = vim.pesc(word)

  for lnum, line in ipairs(lines) do
    for start_, finish_ in line:gmatch('()' .. pattern .. '()') do
      vim.api.nvim_buf_add_highlight(
        0, ns_id, 'WordUnderCursor',
        lnum - 1, start_ - 1, finish_ - 1
      )
    end
  end

  vim.b.word_highlight_active = true
end

vim.keymap.set('n', 'f', _G.toggle_highlight_word, { silent = true })

function highlight_color_codes()
  local color_pattern = "#%x%x%x%x%x%x"
  local function add_highlight(group, color)
    vim.cmd(string.format("highlight %s guifg=%s", group, color))
  end
  for _, color in ipairs(vim.fn.getmatches()) do
    if color.pattern and string.match(color.pattern, color_pattern) then
      vim.fn.matchdelete(color.id)
    end
  end
  local line_num = 0
  for _, line in ipairs(vim.fn.getline(1, '$')) do
    for color_code in string.gmatch(line, color_pattern) do
      local group_name = "ColorCode_" .. color_code:sub(2)
      add_highlight(group_name, color_code)
      vim.fn.matchadd(group_name, color_code)
    end
    line_num = line_num + 1
  end
end

vim.cmd([[
  augroup ColorCodeHighlight
    autocmd!
    autocmd BufEnter,BufWritePost,TextChanged,TextChangedI * lua highlight_color_codes()
  augroup END
]])

