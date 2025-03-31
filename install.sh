#!/usr/bin/env bash

base_url="https://raw.githubusercontent.com/grisha765/my_neovim/main"

mkdir -p ~/.config/nvim/lua
mkdir -p ~/.config/lazygit

wget -O ~/.config/nvim/init.lua $base_url/nvim/init.lua
wget -O ~/.config/lazygit/config.yml $base_url/lazygit/config.yml

lua_modules=(
  "funcs.lua"
  "gpt.lua"
  "highlight.lua"
  "plugins.lua"
  "settings.lua"
  "tabs.lua"
  "terminal.lua"
  "autosave.lua"
  )

for file in "${lua_modules[@]}"; do
  wget -O ~/.config/nvim/lua/${file} $base_url/nvim/lua/${file}
done

nvim
