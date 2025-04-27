-- Установка Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Установка плагинов с Lazy.nvim
require('lazy').setup({
  'neovim/nvim-lspconfig', -- конфигурация lsp
  'hrsh7th/nvim-cmp', -- Основной плагин для автодополнения
  'hrsh7th/cmp-nvim-lsp', -- Источник LSP для nvim-cmp
  'hrsh7th/cmp-buffer', -- Источник буфера
  'hrsh7th/cmp-path', -- Источник путей файловой системы
  'hrsh7th/cmp-cmdline', -- Источник командной строки
  { 'j-hui/fidget.nvim', opts = {} }, -- Статус обновления LSP
  'L3MON4D3/LuaSnip', -- Плагин для сниппетов
  'saadparwaiz1/cmp_luasnip', -- Источник для LuaSnip
  'justinmk/vim-sneak', -- Удобный поиск
  'windwp/nvim-autopairs', -- Форматирование скобок
  'psliwka/vim-smoothie', -- Плавная прокрутка
  { 'nvim-treesitter/nvim-treesitter', build = ":TSUpdate" }, -- Подсветка кода
  { 'kdheepak/lazygit.nvim',
		cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile", },
		dependencies = { "nvim-lua/plenary.nvim", },
		keys = { { "lg", "<cmd>LazyGit<cr>", desc = "LazyGit" } }
	}, -- Плагин для удобного управления git
  -- VS Code Color Schemes
  'Mofiqul/vscode.nvim',
  { 'nvim-telescope/telescope-file-browser.nvim', 
    dependencies = { 'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font } },
  }, -- Удобный файловый менеджер
})

local lspconfig = require('lspconfig')
vim.diagnostic.config({
  virtual_text = {
    prefix = '',
    spacing = 0,
  },
  signs = false,
})

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
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        fallback()
      else
        fallback()
      end
    end, { 'i', 's' }),
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
local servers = { 'pyright', 'ts_ls', 'jdtls'}
local android_sdk = '/home/grisha/.local/share/android-sdk'
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    settings = {
      java = {
        project = {
          referencedLibraries = {
            android_sdk .. '/platforms/android-33/android.jar',
          }
        }
      }
    },
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
  ensure_installed = {
    "python", "javascript", 
    "typescript", "tsx"
  },
  auto_install = false,
  sync_install = #vim.api.nvim_list_uis() == 0,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

-- Настройка nvim-autopairs
require('nvim-autopairs').setup({
  check_ts = true,
  map_cr = true,
})

-- Настройка telescope-file-browser
require('telescope').setup({
  extensions = {
    file_browser = {
      hijack_netrw = true,
      sorting_strategy = 'ascending',
      layout_strategy = 'horizontal',
      layout_config = {
        width = 0.99,
        height = 0.99,
        prompt_position = "top",
      },
    },
  },
})

require('telescope').load_extension('file_browser')
local actions = require("telescope.actions")
local fb = require("telescope").extensions.file_browser.file_browser

_G.openFileBrowserInNewTab = function()
  vim.cmd("tabnew") -- открываем новый таб
  fb({
    attach_mappings = function(prompt_bufnr, map)
      local function closeTelescopeAndTab()
        actions.close(prompt_bufnr)
        vim.cmd("tabclose")
      end

      map("i", "<esc>", closeTelescopeAndTab)
      map("n", "<esc>", closeTelescopeAndTab)

      return true
    end
  })
end

-- Установка цветовой схемы
vim.cmd [[
  colorscheme vscode
  let g:vscode_style = 'dark'
  let g:vscode_transparent = 1
  let g:vscode_italic_comment = 1
]]
