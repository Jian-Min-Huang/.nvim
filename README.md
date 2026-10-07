# .nvim

## Installation

```bash
brew install --cask ghostty
brew install neovim herdr
brew install ripgrep fd lazygit tree-sitter fzf
```

```bash
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git
```

## Configuration

```bash
ln -s ~/.nvim/plugins ~/.config/nvim/lua/plugins
ln -s ~/.nvim/herdr/config.toml ~/.config/herdr/config.toml
```

```bash
mkdir -p ~/Library/LaunchAgents
cp cc.jianminhuang.weatherinfo.plist ~/Library/LaunchAgents/
chmod 644 ~/Library/LaunchAgents/cc.jianminhuang.weatherinfo.plist

shortcuts run WeatherInfo

launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/cc.jianminhuang.weatherinfo.plist
launchctl kickstart -k gui/$(id -u)/cc.jianminhuang.weatherinfo
launchctl print gui/$(id -u)/cc.jianminhuang.weatherinfo | grep 'last exit'
```

```bash
pi --model deepseek/deepseek-flash:medium -p "/skill:add-commit-msg" | tee >(pbcopy)
```
