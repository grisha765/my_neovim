-- Переменная для хранения окна терминала
_G.terminal_win = nil
_G.terminal_buf = nil
_G.previous_win = nil
_G.is_terminal_focused = false

-- Функция для открытия или скрытия терминала
function _G.toggle_terminal()
  if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
    vim.api.nvim_set_current_win(_G.previous_win)
    vim.api.nvim_win_hide(terminal_win)
    terminal_win = nil
  else
    _G.previous_win = vim.api.nvim_get_current_win()

    if _G.terminal_buf and vim.api.nvim_buf_is_valid(_G.terminal_buf) then
      vim.cmd('botright split')
      vim.cmd('resize 10')
      vim.api.nvim_set_current_buf(_G.terminal_buf)
      terminal_win = vim.api.nvim_get_current_win()
    else
      vim.cmd('botright split')
      vim.cmd('resize 10')
      vim.cmd('terminal')
      terminal_win = vim.api.nvim_get_current_win()
      _G.terminal_buf = vim.api.nvim_get_current_buf()
    end
    vim.api.nvim_win_set_option(terminal_win, 'number', false)
    vim.api.nvim_win_set_option(terminal_win, 'relativenumber', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('i', true, false, true), 'n', true)
  end
end

-- Функция для проверки фокуса терминала
function _G.check_terminal_focus()
  if vim.api.nvim_get_current_win() == _G.terminal_win and not _G.is_terminal_focused then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('i', true, false, true), 'n', true)
    _G.is_terminal_focused = true
  elseif vim.api.nvim_get_current_win() ~= _G.terminal_win then
    _G.is_terminal_focused = false
  end
end

-- Привязываем функцию к клавише "t" в Normal режиме
vim.api.nvim_set_keymap('n', '<C-t>', ':lua toggle_terminal()<CR>', { noremap = true, silent = true })

-- Привязываем функцию к Ctrl + t в Terminal режиме
vim.api.nvim_set_keymap('t', '<C-t>', '<C-\\><C-n>:lua toggle_terminal()<CR>', { noremap = true, silent = true })

-- Автокоманда для переключения в режим вставки при входе в окно терминала
vim.api.nvim_exec([[
  augroup TerminalFocus
    autocmd!
    autocmd WinEnter * lua check_terminal_focus()
  augroup END
]], false)

-- Функция для скрытия терминала при переключении вкладок
function _G.hide_terminal_on_tab_change()
  if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
    vim.api.nvim_win_hide(terminal_win)
    terminal_win = nil
  end
end

-- Автокоманда для скрытия терминала при переключении вкладок
vim.api.nvim_exec([[
  augroup TerminalHideOnTabChange
    autocmd!
    autocmd TabEnter * lua hide_terminal_on_tab_change()
  augroup END
]], false)

