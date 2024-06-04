# Neovim Configuration

This is a custom Neovim configuration script written in Lua. It includes various settings, key mappings, and functions to enhance your Neovim experience. Below is a detailed guide on how to set it up and use it.

## Initial Setup

1. **Clone the Repository**: Clone this repository using `git clone`.
2. **Install Neovim**: Ensure you have Neovim installed. You can download it from the [official website](https://neovim.io/).
3. **Place the Configuration File**: Place the `init.lua` file in your Neovim configuration directory, typically `~/.config/nvim/`.

***Install Linux***

```shell
mkdir -p ~/.config/nvim && wget -O ~/.config/nvim/init.lua https://raw.githubusercontent.com/grisha765/my_neovim/main/nvim/init.lua && nvim
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
  - **LazyGit**: Use `lg` to open LazyGit.
