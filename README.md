# nvim

nvim config

一些nvim的配置

# 依赖软件包

- lua
- luarocks
- python3
- nodejs
- unzip

# 依赖lsp

```bash
pipx install cmake-language-server
```

# 编译neovim

```bash
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
```

默认安装位置为`/usr/local`


