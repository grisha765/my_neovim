#!/usr/bin/env bash

script_dir=$(dirname "$(realpath "$BASH_SOURCE")")

base_url="https://raw.githubusercontent.com/grisha765/my_neovim/main"

mkdir -p ~/.config/nvim/lua
mkdir -p ~/.config/lazygit

if [ -d "$script_dir/.git" ]; then
  ln -sf $script_dir/nvim/init.lua ~/.config/nvim/init.lua
  ln -sf $script_dir/lazygit/config.yml ~/.config/lazygit/config.yml
else
  wget -O ~/.config/nvim/init.lua $base_url/nvim/init.lua
  wget -O ~/.config/lazygit/config.yml $base_url/lazygit/config.yml
fi

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
  if [ -d "$script_dir/.git" ]; then
    ln -sf $script_dir/nvim/lua/${file} ~/.config/nvim/lua/${file}
  else
    wget -O ~/.config/nvim/lua/${file} $base_url/nvim/lua/${file}
  fi
done

nvim
