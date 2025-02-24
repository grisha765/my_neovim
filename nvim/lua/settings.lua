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

-- Открытие telescope-file-browser в новой вкладке
vim.api.nvim_set_keymap("n", "<C-n>", "<Cmd>lua openFileBrowserInNewTab()<CR>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd(":Telescope file_browser")
    end
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

