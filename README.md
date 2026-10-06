# .nvim

neovim configurations

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
