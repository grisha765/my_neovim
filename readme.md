# Neovim Configuration

This is a custom Neovim configuration script written in Lua. It includes various settings, key mappings, and functions to enhance your Neovim experience. Below is a detailed guide on how to set it up and use it.

## Initial Setup

1. **Clone the Repository**: Clone this repository using `git clone`.
2. **Install Neovim**: Ensure you have Neovim installed. You can download it from the [official website](https://neovim.io/).
3. **Place the Configuration File**: Place the `init.lua` file in your Neovim configuration directory, typically `~/.config/nvim/`.

### Install Linux/macOS

***Download utils***

- **Arch Linux**: 
  `sudo pacman -S neovim lazygit nodejs npm`
- **Debian**: 
  `sudo apt update && sudo apt install neovim nodejs npm && sudo add-apt-repository ppa:lazygit-team/release && sudo apt update && sudo apt install lazygit`
- **Fedora**: 
  `sudo dnf install neovim nodejs npm && sudo dnf copr enable atim/lazygit -y && sudo dnf install lazygit`
- **macOS**: 
  `brew install neovim lazygit node`
- **Termux**: 
  `pkg install neovim lazygit nodejs`

***Download configs***

```shell
mkdir -p ~/.config/nvim && mkdir -p ~/.config/lazygit && wget -O ~/.config/nvim/init.lua https://raw.githubusercontent.com/grisha765/my_neovim/main/nvim/init.lua && wget -O ~/.config/lazygit/config.yml https://raw.githubusercontent.com/grisha765/my_neovim/main/lazygit/config.yml && nvim
```

### Install Windows

**Download utils**

- **Scoop**: 
  `scoop install neovim lazygit gcc nodejs`
- **Chocolatey**: 
  `choco install neovim lazygit mingw nodejs`
- **Winget**: 
  `winget install Neovim.Neovim jesseduffield.lazygit GNU.GCC OpenJS.NodeJS`

***Download configs***

```shell
cmd.exe /c "mkdir %APPDATA%\lazygit & mkdir %USERPROFILE%\AppData\Local\nvim & curl -L "https://raw.githubusercontent.com/grisha765/my_neovim/main/nvim/init.lua" -o "%USERPROFILE%\AppData\Local\nvim\init.lua" --insecure & curl -L "https://raw.githubusercontent.com/grisha765/my_neovim/main/lazygit/config.yml" -o "%APPDATA%\lazygit\config.yml" --insecure & start nvim"
```

### Autocomplete python

***Download pyright***

```shell
pip install pyright
```

### Key Features

- **Code Completion**: Code completion in popular programming languages.
- **Syntax Highlighting**: Turns on syntax highlighting for better code readability.
- **Custom Key Mappings**:
  - **Switch Between Normal and Insert Mode**: Use the `INSERT` key.
  - **System Clipboard Integration**: 
    - `Ctrl + C` to copy
    - `Ctrl + V` to paste
    - `Ctrl + X` to cut
    - `Ctrl + Z` to undo
  - **Toggle Highlighting of Current Word**: Press `f` in normal mode.
  - **Open/Close Terminal**: Use `Ctrl + t` in normal mode.
  - **Simple File Manager**: Open with `Ctrl + n`.
  - **Navigate Tabs**: Use `Tab` and `Shift + Tab` to switch between tabs.
  - **LazyGit**: Use `lg` to open LazyGit in normal mode.
