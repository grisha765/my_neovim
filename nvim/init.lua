-- Включить номера строк
vim.opt.number = true

-- Изменить цвет фона
-- vim.cmd('highlight Normal guibg=1E1E1E')

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

-- Функция для включения/выключения подсветки всех вхождений слова под курсором
function _G.toggle_highlight_word()
  if vim.b.highlight_word_enabled then
    -- Удаляем все подсветки
    vim.cmd("silent! syntax clear WordUnderCursor")
    vim.b.highlight_word_enabled = false
  else
    local word = vim.fn.expand('<cword>')
    if word ~= '' then
      -- Устанавливаем синтаксическое правило для подсветки слова
      vim.cmd(string.format('syntax match WordUnderCursor "\\<%s\\>"', word))
      -- Настройка цвета подсветки
      vim.cmd('highlight WordUnderCursor cterm=bold ctermbg=lightyellow guibg=#00008B')
      vim.b.highlight_word_enabled = true
    end
  end
end

-- Привязываем функцию к клавише 'f' (в нормальном режиме)
vim.api.nvim_set_keymap('n', 'f', ':lua toggle_highlight_word()<CR>', { noremap = true, silent = true })

-- Функция для выполнения команд Git и отображения результата в командной строке
local function git_commit_push(commit_message)
  -- Сохранение текущего файла
  vim.cmd('write')

  -- Получение текущего файла
  local current_file = vim.fn.expand("%")

  -- Команда git add
  local git_add_cmd = "git add " .. vim.fn.shellescape(current_file)
  local add_result = vim.fn.systemlist(git_add_cmd)

  -- Получение текущей ветки
  local git_branch_cmd = "git rev-parse --abbrev-ref HEAD"
  local branch_result = vim.fn.systemlist(git_branch_cmd)
  local current_branch = branch_result[1]

  -- Команда git commit
  local git_commit_cmd = "git commit -m " .. vim.fn.shellescape(commit_message)
  local commit_result = vim.fn.systemlist(git_commit_cmd)

  -- Команда git push
  local git_push_cmd = "git push origin " .. current_branch
  local push_result = vim.fn.systemlist(git_push_cmd)

  -- Вывод результата в командной строке
  if #add_result > 0 then
    vim.notify(table.concat(add_result, "\n"), vim.log.levels.INFO)
  end

  if #commit_result > 0 then
    vim.notify(table.concat(commit_result, "\n"), vim.log.levels.INFO)
  end

  if #push_result > 0 then
    vim.notify(table.concat(push_result, "\n"), vim.log.levels.INFO)
  end
end

-- Команда для выполнения функции
vim.api.nvim_create_user_command('Ga', function(opts)
  git_commit_push(opts.args)
end, { nargs = 1 })
-- Пример использования: :Ga "commit message"

-- Переменная для хранения окна терминала
_G.terminal_win = nil
_G.terminal_buf = nil
_G.previous_win = nil
_G.is_terminal_focused = false

-- Функция для открытия или скрытия терминала
function _G.toggle_terminal()
  -- Если окно терминала уже существует и открыто
  if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
    -- Закрыть окно терминала и вернуть фокус в исходное окно
    vim.api.nvim_set_current_win(_G.previous_win)
    vim.api.nvim_win_hide(terminal_win)
    terminal_win = nil
  else
    -- Сохранить текущее окно для возврата при скрытии терминала
    _G.previous_win = vim.api.nvim_get_current_win()

    if _G.terminal_buf and vim.api.nvim_buf_is_valid(_G.terminal_buf) then
      -- Если буфер терминала существует, открыть его в новом сплите
      vim.cmd('botright split')
      vim.cmd('resize 10')
      vim.api.nvim_set_current_buf(_G.terminal_buf)
      terminal_win = vim.api.nvim_get_current_win()
    else
      -- Открыть новый сплит внизу
      vim.cmd('botright split')
      -- Установить высоту сплита
      vim.cmd('resize 10')
      -- Открыть терминал
      vim.cmd('terminal')
      -- Сохранить окно и буфер терминала
      terminal_win = vim.api.nvim_get_current_win()
      _G.terminal_buf = vim.api.nvim_get_current_buf()
    end
    -- Отключить номера строк для терминала
    vim.api.nvim_win_set_option(terminal_win, 'number', false)
    vim.api.nvim_win_set_option(terminal_win, 'relativenumber', false)
    -- Войти в режим вставки в терминале
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

-- Опционально, можно настроить автокоманду для закрытия терминала, когда он не нужен
vim.api.nvim_exec([[
  augroup TerminalClose
    autocmd!
    autocmd TermClose * lua _G.terminal_buf = nil
  augroup END
]], false)

-- Инициализация функции для подсветки цветовых кодов
function highlight_color_codes()
  -- Регулярное выражение для поиска цветовых кодов
  local color_pattern = "#%x%x%x%x%x%x"

  -- Функция для добавления подсветки
  local function add_highlight(group, color)
    vim.cmd(string.format("highlight %s guifg=%s", group, color))
  end

  -- Удаление существующих групп подсветки для цветовых кодов
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


-- Простенький файловый менеджер для Neovim на Lua

-- Глобальные переменные для стека каталогов
local dir_stack = {}

-- Функция для открытия окна файлового менеджера в новой вкладке
function _G.open_file_manager()
    -- Получение текущего пути
    local cwd = vim.fn.getcwd()
    
    -- Команда для открытия новой вкладки
    vim.cmd('tabnew')
    
    -- Создание буфера
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)
    
    -- Функция для отображения файлов и папок
    local function display_files()
        local files = vim.fn.readdir(cwd)
        local lines = { ".." }  -- Добавляем ".." для перехода на уровень выше
        for _, file in ipairs(files) do
            table.insert(lines, file)
        end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        
        -- Установка курсора на первую строку
        vim.api.nvim_win_set_cursor(0, {1, 0})
        
        -- Очистка предыдущих подсветок
        vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)

        -- Подсветка папок
        for i, file in ipairs(lines) do
            local filepath = cwd .. '/' .. file
            if file == ".." or vim.fn.isdirectory(filepath) == 1 then
                vim.api.nvim_buf_add_highlight(buf, -1, 'Directory', i - 1, 0, -1)
            end
        end
    end
    
    -- Отображение файлов и папок
    display_files()
    
    -- Функция для обработки нажатия Enter на строке
    function _G.on_enter()
        local current_buf = vim.api.nvim_get_current_buf()
        if current_buf ~= buf then return end  -- Проверка, чтобы функция выполнялась только для текущего буфера
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local line_num = cursor_pos[1]
        local filename = vim.api.nvim_buf_get_lines(buf, line_num - 1, line_num, false)[1]
        
        if filename == ".." then
            local parent_dir = vim.fn.fnamemodify(cwd, ":h")
            if parent_dir ~= cwd then
                table.insert(dir_stack, cwd)
                cwd = parent_dir
                display_files()
            end
            return
        end
        
        local filepath = cwd .. '/' .. filename
        if vim.fn.isdirectory(filepath) == 1 then
            table.insert(dir_stack, cwd)
            cwd = filepath
            display_files()
        else
            vim.cmd('edit ' .. filepath)
        end
    end
    
    -- Функция для возврата назад
    function _G.go_back()
        local current_buf = vim.api.nvim_get_current_buf()
        if current_buf ~= buf then return end  -- Проверка, чтобы функция выполнялась только для текущего буфера
        if #dir_stack > 0 then
            cwd = table.remove(dir_stack)
            display_files()
        else
            local parent_dir = vim.fn.fnamemodify(cwd, ":h")
            if parent_dir ~= cwd then
                cwd = parent_dir
                display_files()
            end
        end
    end

    -- Привязка нажатия Enter к функции on_enter
    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', ':lua _G.on_enter()<CR>', { noremap = true, silent = true })
    
    -- Привязка нажатия Backspace к функции go_back
    vim.api.nvim_buf_set_keymap(buf, 'n', '<BS>', ':lua _G.go_back()<CR>', { noremap = true, silent = true })
end

-- Привязка Ctrl+n к функции открытия файлового менеджера
vim.api.nvim_set_keymap('n', '<C-n>', ':lua _G.open_file_manager()<CR>', { noremap = true, silent = true })

-- Определение подсветки для папок
vim.cmd('highlight Directory guifg=LightBlue')

-- Запуск файлового менеджера при старте Neovim, если не открываются файлы
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if #vim.fn.argv() == 0 then 
            _G.open_file_manager()
	    vim.cmd('tabonly') 
        end
    end,
})

-- Настройка отображения вкладок в Neovim

-- Привязки клавиш для переключения между вкладками
vim.api.nvim_set_keymap('n', '<Tab>', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', ':tabprevious<CR>', { noremap = true, silent = true })

-- Функция для получения короткого имени файла из полного пути
local function get_short_filename(filename)
    return filename:match("^.+/(.+)$") or filename
end

-- Функция для форматирования вкладок
function _G.tabline()
    local s = ''
    for i = 1, vim.fn.tabpagenr('$') do
        local winnr = vim.fn.tabpagewinnr(i)
        local bufnr = vim.fn.tabpagebuflist(i)[winnr]
        local bufname = vim.fn.bufname(bufnr)
        local short_name = get_short_filename(bufname)

        if short_name == '' then
            short_name = '[No Name]'
        end

        if i == vim.fn.tabpagenr() then
            s = s .. '%' .. i .. 'T' .. '%' .. '#TabLineSel#' .. short_name .. '%#TabLine#' .. '%T'
        else
            s = s .. '%' .. i .. 'T' .. short_name .. '%T'
        end

        s = s .. ' '
    end
    s = s .. '%#TabLineFill#'
    return s
end

-- Установка строки состояния вкладок
vim.o.tabline = '%!v:lua.tabline()'

-- Установка Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Последний стабильный релиз
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Установка плагинов с Lazy.nvim
require('lazy').setup({
  -- LSP Config
  'neovim/nvim-lspconfig',
  -- Autocompletion plugins
  'hrsh7th/nvim-cmp', -- Основной плагин для автодополнения
  'hrsh7th/cmp-nvim-lsp', -- Источник LSP для nvim-cmp
  'hrsh7th/cmp-buffer', -- Источник буфера
  'hrsh7th/cmp-path', -- Источник путей файловой системы
  'hrsh7th/cmp-cmdline', -- Источник командной строки
  'L3MON4D3/LuaSnip', -- Плагин для сниппетов
  'saadparwaiz1/cmp_luasnip', -- Источник для LuaSnip
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
  -- VS Code Color Schemes
  'Mofiqul/vscode.nvim',
})

local lspconfig = require('lspconfig')
local cmp = require('cmp')

-- Настройка nvim-cmp
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 3 },
    { name = 'path' },
  })
})

-- Настройка LSP серверов
local servers = { 'pyright' }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = function(client, bufnr)
      -- Настройка ключевых привязок для LSP
      local opts = { noremap=true, silent=true }
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    end,
  }
end
-- Настройка Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp", "lua", "python", "javascript", "html", "css", "json" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

-- Установка цветовой схемы
vim.cmd [[
  colorscheme vscode
  let g:vscode_style = 'dark'
  let g:vscode_transparent = 1
  let g:vscode_italic_comment = 1
]]

