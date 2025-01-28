-- Эмуляция "cd /path/to && nvim file"
vim.api.nvim_create_augroup('ChangeDirectory', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = 'ChangeDirectory',
  pattern = '*',
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_get_option(buf, 'buftype') ~= 'terminal' then
      local file_dir = vim.fn.expand('%:p:h')
      vim.cmd('cd ' .. file_dir)
    end
  end,
})

-- Функция для выполнения команд Git и отображения результата в командной строке
local function git_commit_push(commit_message)
  vim.cmd('write')

  local current_file = vim.fn.expand("%")

  local git_add_cmd = "git add " .. vim.fn.shellescape(current_file)
  local add_result = vim.fn.systemlist(git_add_cmd)

  local git_branch_cmd = "git rev-parse --abbrev-ref HEAD"
  local branch_result = vim.fn.systemlist(git_branch_cmd)
  local current_branch = branch_result[1]

  local git_commit_cmd = "git commit -m " .. vim.fn.shellescape(commit_message)
  local commit_result = vim.fn.systemlist(git_commit_cmd)

  local git_push_cmd = "git push origin " .. current_branch
  local push_result = vim.fn.systemlist(git_push_cmd)

  local function handle_push_error()
    vim.ui.input({ prompt = 'Ошибка при push. Хотите выполнить git pull --rebase? [Y/n] ' }, function(input)
      if input == nil or input:lower() == 'y' or input == '' then
        local git_pull_cmd = "git pull --rebase"
        local pull_result = vim.fn.systemlist(git_pull_cmd)
        vim.notify(table.concat(pull_result, "\n"), vim.log.levels.INFO)

        if vim.v.shell_error == 0 then
          push_result = vim.fn.systemlist(git_push_cmd)
          vim.notify(table.concat(push_result, "\n"), vim.log.levels.INFO)
        else
          vim.notify("git pull --rebase завершился с ошибкой", vim.log.levels.ERROR)
        end
      else
        vim.notify("git push отменен пользователем", vim.log.levels.INFO)
      end
    end)
  end

  if #add_result > 0 then
    vim.notify(table.concat(add_result, "\n"), vim.log.levels.INFO)
  end

  if #commit_result > 0 then
    vim.notify(table.concat(commit_result, "\n"), vim.log.levels.INFO)
  end

  if #push_result > 0 then
    vim.notify(table.concat(push_result, "\n"), vim.log.levels.INFO)
    if vim.v.shell_error ~= 0 then
      handle_push_error()
    end
  end
end

-- Команда для выполнения функции
vim.api.nvim_create_user_command('Ga', function(opts)
  git_commit_push(opts.args)
end, { nargs = 1 })

