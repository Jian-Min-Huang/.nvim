# .nvim

## Installation

```bash
brew install --cask ghostty
brew install neovim herdr yazi
brew install ripgrep fd lazygit tree-sitter fzf imagemagick tig
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
ln -s ~/.nvim/config ~/.config/nvim/lua/config
ln -s ~/.nvim/plugins ~/.config/nvim/lua/plugins
ln -s ~/.nvim/herdr/config.toml ~/.config/herdr/config.toml
ln -s ~/.nvim/tig/.tigrc ~/.tigrc
ln -s ~/.nvim/yazi/yazi.toml ~/.config/yazi/yazi.toml
ln -s ~/.nvim/yazi/init.lua ~/.config/yazi/init.lua
ya pkg add yazi-rs/plugins:full-border
ya pkg add yazi-rs/plugins:no-status
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

## .zshrc

```text
alias nv='nvim'
alias y='yazi'
alias del='trash'
alias ls='eza -aghlH --sort=Name --time-style relative --group-directories-last --git --octal-permissions --icons=auto'

export EDITOR=nvim

# pbcopy: also send OSC 52 so the attached terminal (e.g. Termius over SSH/herdr) gets the text
pbcopy() {
  local data
  data=$(cat; print -n x); data=${data%x}
  print -rn -- "$data" | command pbcopy
  if [[ -t 1 ]]; then
    printf '\033]52;c;%s\a' "$(print -rn -- "$data" | base64 | tr -d '\n')"
  fi
}

# Fall back to the macOS built-in ssh-agent when SSH_AUTH_SOCK is unusable (e.g. remote SSH login)
if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
  export SSH_AUTH_SOCK=$(launchctl print gui/$(id -u)/com.openssh.ssh-agent 2>/dev/null | awk '/SSH_AUTH_SOCK =>/ {print $3; exit}')
fi
```
