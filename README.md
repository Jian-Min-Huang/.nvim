# .nvim

## Installation

```bash
brew install neovim herdr
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

```bash
brew install --cask ghostty
brew install ripgrep fd lazygit tree-sitter fzf
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
