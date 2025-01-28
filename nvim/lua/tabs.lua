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

