-- Эти переменные нужны, чтобы хранить окно терминала, буфер и предыдущее окно
_G.terminal_win = nil
_G.terminal_buf = nil
_G.previous_win = nil

-- Открыть терминал (если он уже открыт, просто фокусируемся на нём)
local function open_terminal()
  if _G.terminal_win and vim.api.nvim_win_is_valid(_G.terminal_win) then
    vim.api.nvim_set_current_win(_G.terminal_win)
    return
  end

  _G.previous_win = vim.api.nvim_get_current_win()

  if _G.terminal_buf and vim.api.nvim_buf_is_valid(_G.terminal_buf) then
    vim.cmd('botright split')
    vim.cmd('resize 10')
    vim.api.nvim_set_current_buf(_G.terminal_buf)
    _G.terminal_win = vim.api.nvim_get_current_win()
  else
    vim.cmd('botright split')
    vim.cmd('resize 10')
    vim.cmd('terminal')
    _G.terminal_win = vim.api.nvim_get_current_win()
    _G.terminal_buf = vim.api.nvim_get_current_buf()
  end

  vim.api.nvim_win_set_option(_G.terminal_win, 'number', false)
  vim.api.nvim_win_set_option(_G.terminal_win, 'relativenumber', false)

  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('i', true, false, true),
    'n',
    true
  )
end

-- Скрыть терминал (если он вообще открыт)
local function close_terminal()
  if
    _G.terminal_win
    and type(_G.terminal_win) == 'number'
    and vim.api.nvim_win_is_valid(_G.terminal_win)
  then
    vim.api.nvim_win_hide(_G.terminal_win)
  end
  _G.terminal_win = nil
end

-- Основная функция переключения терминала (открыть/скрыть)
function _G.toggle_terminal()
  if
    _G.terminal_win
    and type(_G.terminal_win) == 'number'
    and vim.api.nvim_win_is_valid(_G.terminal_win)
  then
    close_terminal()
    if
      _G.previous_win
      and vim.api.nvim_win_is_valid(_G.previous_win)
    then
      vim.api.nvim_set_current_win(_G.previous_win)
    end
  else
    -- Иначе открываем
    open_terminal()
  end
end

-- Функция, которая будет автоматически скрывать терминал,
-- если мы переключаемся в другое окно
function _G.auto_hide_terminal_on_focus_lost()
  local current_win = vim.api.nvim_get_current_win()
  if
    _G.terminal_win
    and type(_G.terminal_win) == 'number'
    and vim.api.nvim_win_is_valid(_G.terminal_win)
  then
    if current_win ~= _G.terminal_win then
      close_terminal()
      if
        _G.previous_win
        and vim.api.nvim_win_is_valid(_G.previous_win)
        and current_win ~= _G.previous_win
      then
        vim.api.nvim_set_current_win(_G.previous_win)
      end
    end
  end
end

-- Шорткаты для переключения терминала в Normal- и Terminal-режиме
vim.api.nvim_set_keymap('n', '<C-t>', ':lua toggle_terminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-t>', '<C-\\><C-n>:lua toggle_terminal()<CR>', { noremap = true, silent = true })

-- Автокоманда: на каждом WinEnter проверяем, вышли ли мы из терминала
vim.api.nvim_exec([[
  augroup TerminalAutoHide
    autocmd!
    autocmd WinEnter * lua auto_hide_terminal_on_focus_lost()
  augroup END
]], false)

