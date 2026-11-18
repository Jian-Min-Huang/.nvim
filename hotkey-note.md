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

- <leader> + ?
- <leader> + w
- <leader> + g
- <leader> + 1..9
