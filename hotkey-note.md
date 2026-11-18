# Hot Key Note

## Git

| Alias | 原本指令 |
| --- | --- |
| `gfa && gb -vv` | `git fetch --all --tags --prune --jobs=10 && git branch -vv` |
| `gprv` | `git pull --rebase -v` |
| `gco` | `git checkout` |
| `gcl` | `git clone --recurse-submodules` |
| `gp` | `git push` |
| `gm` | `git merge` |
| `grb` | `git rebase` |
| `gsi` | `git submodule init` |
| `gsu` | `git submodule update` |
| `gsuri` | `git submodule update --recursive --init` |

## PI

- `pi --model deepseek/deepseek-flash:medium -p "/skill:add-commit-msg" | tee >(pbcopy)`
- `commit_msg=$(pi --model deepseek/deepseek-flash:medium -p "/skill:add-commit-msg") && git commit -m $commit_msg`

## herdr

| 指令 | 說明 |
| --- | --- |
| <leader> + ? | keybinds |
| <leader> + w | workspace navigation |
| <leader> + g | session navigator |
| <leader> + 1..9 | switch workspace |

## LazyVim

| 指令 | 說明 |
| --- | --- |
| <C-h> | Go to Left Window |
| <C-j> | Go to Lower Window |
| <C-k> | Go to Upper Window |
| <C-l> | Go to Right Window |
| <S-h> | Prev Buffer |
| <S-l> | Next Buffer |
| <leader>gg | GitUi (Root Dir) |
| <leader>bb | Switch to Other Buffer |
| <leader>e | Explorer Snacks (root dir) |
| <C-/> | Terminal (Root Dir) |
