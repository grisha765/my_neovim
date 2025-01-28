-- Включить номера строк
vim.opt.number = true

-- Изменить цвет фона
-- vim.cmd('highlight Normal guibg=1E1E1E')

-- Установить привязку клавиш 'jk' для выхода из режима вставки
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- Включить подсветку синтаксиса
vim.cmd('syntax on')

-- Переключение между Normal и Insert с помощью клавиши "INSERT"
vim.api.nvim_set_keymap('n', '<Insert>', 'i', { noremap = true })
vim.api.nvim_set_keymap('i', '<Insert>', '<Esc>', { noremap = true })

-- Настройка Ctrl + C для копирования в системный буфер обмена
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })

-- Настройка Ctrl + V для вставки из системного буфера обмена
vim.api.nvim_set_keymap('n', '<C-v>', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-v>', '<Esc>"+pa', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<C-v>', '<C-r>+', { noremap = true, silent = true })

-- Настройка Ctrl + X для вырезания в системный буфер обмена
vim.api.nvim_set_keymap('v', '<C-x>', '"+d', { noremap = true, silent = true })

-- Настройки для отмены и повторения операций
-- Настройки для нормального режима
vim.api.nvim_set_keymap('n', '<C-z>', 'u', { noremap = true, silent = true })

-- Настройки для вставочного режима
vim.api.nvim_set_keymap('i', '<C-z>', '<Esc>ui', { noremap = true, silent = true })

-- Настройка сохранения файла
-- Настраиваем карту клавиш для нормального режима
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })

-- Настраиваем карту клавиш для режима вставки
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true })

-- Создаем команды для Tab и Shift+Tab в визуальном режиме
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

-- Настройка NetRW
vim.api.nvim_set_keymap('n', '<C-n>', ':tabnew<CR>:Explore<CR>', { noremap = true, silent = true })
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd("Explore")
    end
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "q", ":q<CR>", { noremap = true, silent = true })
  end
})

-- Устанавливаем глобальные настройки по умолчанию для всех файлов
vim.opt.expandtab = true  -- Преобразовывать табы в пробелы
vim.opt.tabstop = 2       -- Количество пробелов, соответствующих одному табу
vim.opt.shiftwidth = 2    -- Количество пробелов для отступов

-- Функция для установки отступов в Python файлах
local function set_python_indent()
  vim.bo.tabstop = 4
  vim.bo.shiftwidth = 4
end

-- Автокоманда для настройки отступов в Python файлах
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = set_python_indent,
})

