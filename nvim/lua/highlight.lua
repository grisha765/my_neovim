-- Функция для включения/выключения подсветки всех вхождений слова под курсором
function _G.toggle_highlight_word()
  if vim.b.highlight_word_enabled then
    vim.cmd("silent! syntax clear WordUnderCursor")
    vim.b.highlight_word_enabled = false
  else
    local word = vim.fn.expand('<cword>')
    if word ~= '' then
      vim.cmd(string.format('syntax match WordUnderCursor "\\<%s\\>"', word))
      vim.cmd('highlight WordUnderCursor cterm=bold ctermbg=lightyellow guibg=#00008B')
      vim.b.highlight_word_enabled = true
    end
  end
end

-- Привязываем функцию к клавише 'f' (в нормальном режиме)
vim.api.nvim_set_keymap('n', 'f', ':lua _G.toggle_highlight_word()<CR>', { noremap = true, silent = true })

-- Инициализация функции для подсветки цветовых кодов
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

-- Автокоманда для обновления подсветки при изменении буфера
vim.cmd([[
  augroup ColorCodeHighlight
    autocmd!
    autocmd BufEnter,BufWritePost,TextChanged,TextChangedI * lua highlight_color_codes()
  augroup END
]])

