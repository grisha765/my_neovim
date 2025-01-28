-- Финкционал работы с GPT ботами
local function send_gpt_request(selected_text, additional_text, explanation, end_line)
    local api_url = "http://127.0.0.1:8000/v1/chat/completions"
    local api_key = "adminapi007"
    local model = "gpt-3.5-duck"
    local temperature = 0.7

    local request_data = {
        model = model,
        messages = {
            {
                role = "user",
                content = additional_text .. "\n\n" .. selected_text .. "\n\n" .. explanation
            }
        },
        temperature = temperature
    }

    local json_data = vim.fn.json_encode(request_data)

    local temp_file = "/tmp/gpt_request.json"
    local file = io.open(temp_file, "w")
    if file then
        file:write(json_data)
        file:close()
    else
        print("Ошибка при создании временного файла")
        return
    end

    local curl_command = string.format(
        "curl -s -X POST %s -H 'Content-Type: application/json' -H 'Authorization: Bearer %s' --data @%s",
        api_url, api_key, temp_file
    )

    local handle = io.popen(curl_command)
    local result = handle:read("*a")
    handle:close()

    os.remove(temp_file)

    local status_ok, response = pcall(vim.fn.json_decode, result)
    if not status_ok then
        print("Ошибка при декодировании ответа")
        return
    end

    if response and response.choices and response.choices[1] and response.choices[1].message then
        local reply = response.choices[1].message.content

        reply = reply:gsub("Copy Code", "")

        local reply_lines = vim.split(reply, "\n", { trimempty = false })
        if #reply_lines >= 3 then
            if reply_lines[2]:match("^%s*$") then
                table.remove(reply_lines, 2)
            end
        end

        vim.fn.append(end_line, reply_lines)
    else
        print("Ошибка при получении ответа от API")
    end
end

-- Команда для отправки запроса на API
vim.api.nvim_create_user_command('GPT', function(opts)
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.fn.getline(start_pos[2], end_pos[2])
    if #lines > 0 then
        lines[1] = string.sub(lines[1], start_pos[3])
        lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    end
    local selected_text = table.concat(lines, "\n")
    local additional_text = opts.args
    local explanation = "Твой ответ должен содержать только код. Описание кода должно быть в комментариях или док строках к функциям. Обязательно пиши хоть какие-то коментарии к коду, чтобы было легче понять и работать с ним."
    send_gpt_request(selected_text, additional_text, explanation, end_pos[2])
end, { nargs = 1, range = true })

