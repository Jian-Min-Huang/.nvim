# oh-my-zsh git plugin alias 速查

- 來源：<https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/README.md>
- 整理日期：2026-10-07
- 啟用方式：在 `~/.zshrc` 的 `plugins=(... git)` 加入 `git`

> ⚠️ 代表可能毀掉工作成果或改寫歷史，使用前要小心。

## 目錄

- [命名規則](#命名規則)
- [綜合](#綜合)
- [add / apply / am](#add--apply--am)
- [bisect](#bisect用二分搜尋找出問題-commit)
- [blame / branch](#blame--branch)
- [checkout / switch](#checkout--switch)
- [cherry-pick](#cherry-pick)
- [clone / clean](#clone--clean)
- [commit](#commit)
- [describe / diff](#describe--diff)
- [fetch](#fetch)
- [GUI](#gui)
- [log](#log)
- [ls-files / update-index](#ls-files--update-index)
- [merge](#merge)
- [pull](#pull)
- [push](#push)
- [rebase](#rebase)
- [reflog / remote](#reflog--remote)
- [reset / restore](#reset--restore這一區要特別小心)
- [revert / rm](#revert--rm)
- [shortlog / show](#shortlog--show)
- [stash](#stash)
- [status](#status)
- [submodule / svn](#submodule--svn)
- [tag](#tag)
- [worktree](#worktree)
- [WIP](#wip快速暫停手邊的工作)
- [輔助函式](#輔助函式)
- [改過名稱的 alias](#改過名稱的-alias)

---

## 命名規則

大部分名稱都有固定模式，熟悉之後很好猜：

| 模式 | 意思 | 例子 |
|---|---|---|
| `g` + 子指令首字母 + 參數首字母 | git 縮寫 | `gaa` = **g**it **a**dd --**a**ll |
| 結尾 `!` | amend 或 force，會改寫歷史 | `gc!`、`gpf!` |
| 結尾 `a` / `c` / `s` | abort / continue / skip | `grba`、`grbc`、`grbs` |
| 含 `m` | main 分支（有 `main` 就用 `main`，否則用 `master`） | `gcm`、`grbm` |
| 含 `d` | develop 分支（`dev`/`devel`/`development`/`develop`） | `gcd`、`gswd` |
| 含 `om` / `um` | `origin/main` / `upstream/main` | `grbom`、`gmum` |
| `gg` 開頭 | 目前分支對 origin 的 pull/push | `ggl`、`ggp` |

---

## 綜合

| Alias | 指令 | 說明 |
|---|---|---|
| `g` | `git` | git 本身 |
| `grt` | `cd "$(git rev-parse --show-toplevel)"` | cd 到 repo 根目錄（git root）。不在 repo 裡就留在原地 |
| `ghh` | `git help` | 查看說明 |
| `gcf` | `git config --list` | 列出所有 git 設定 |

## add / apply / am

| Alias | 指令 | 說明 |
|---|---|---|
| `ga` | `git add` | 加入暫存區 |
| `gaa` | `git add --all` | 把所有變更加入暫存區，包含新檔案和刪除 |
| `gapa` | `git add --patch` | 互動式逐段（hunk）挑選要暫存的內容 |
| `gau` | `git add --update` | 只暫存已追蹤檔案的變更，不加新檔案 |
| `gav` | `git add --verbose` | 加入時列出每個檔案 |
| `gap` | `git apply` | 把 patch 檔套用到工作目錄，不會產生 commit |
| `gapt` | `git apply --3way` | patch 無法乾淨套用時改用三方合併，並留下衝突標記 |
| `gam` | `git am` | 套用 `git format-patch` 產生的 patch（email 格式），並**直接建立 commit** |
| `gama` | `git am --abort` | 中止 am |
| `gamc` | `git am --continue` | 繼續 am |
| `gams` | `git am --skip` | 跳過目前的 patch |
| `gamscp` | `git am --show-current-patch` | 顯示 am 目前卡住的那個 patch |

## bisect（用二分搜尋找出問題 commit）

| Alias | 指令 | 說明 |
|---|---|---|
| `gbs` | `git bisect` | bisect 本身 |
| `gbss` | `git bisect start` | 開始 bisect |
| `gbsb` | `git bisect bad` | 把目前 commit 標記為 bad |
| `gbsg` | `git bisect good` | 把目前 commit 標記為 good |
| `gbsn` | `git bisect new` | 標記為 new。效果同 bad，用在要找的不是 bug 的情況，例如「效能是從哪個 commit 開始變好的」 |
| `gbso` | `git bisect old` | 標記為 old。效果同 good |
| `gbsr` | `git bisect reset` | 結束 bisect，回到開始前的位置 |

## blame / branch

| Alias | 指令 | 說明 |
|---|---|---|
| `gbl` | `git blame -w` | 逐行顯示作者，忽略空白變更 |
| `gb` | `git branch` | 列出本地分支 |
| `gba` | `git branch --all` | 列出本地加遠端分支 |
| `gbr` | `git branch --remotes` | 只列出遠端分支 |
| `gbd` | `git branch --delete` | 刪除分支，尚未合併的會拒絕刪除 |
| `gbD` | `git branch --delete --force` | ⚠️ 強制刪除分支，不管有沒有合併 |
| `gbm` | `git branch --move` | 重新命名分支（`gbm old new`） |
| `gbnm` | `git branch --no-merged` | 列出尚未合併進目前分支的分支 |
| `ggsup` | `git branch --set-upstream-to=origin/$(git_current_branch)` | 把目前分支的 upstream 設為 `origin/<同名分支>` |
| `gbg` | `git branch -vv`，篩出 `: gone]` | 列出遠端分支已經 gone（被刪除，例如 PR 合併後）的本地分支 |
| `gbgd` | 同上，再交給 `git branch -d` | 安全刪除這些 gone 分支。squash merge 過的分支會被 git 當成未合併，所以會刪除失敗 |
| `gbgD` | 同上，再交給 `git branch -D` | ⚠️ 強制刪除這些 gone 分支 |

## checkout / switch

| Alias | 指令 | 說明 |
|---|---|---|
| `gco` | `git checkout` | checkout |
| `gcor` | `git checkout --recurse-submodules` | checkout，連 submodule 一起更新 |
| `gcb` | `git checkout -b` | 建立新分支並切換過去 |
| `gcB` | `git checkout -B` | ⚠️ 建立分支；**若分支已存在就重設它**到起點 |
| `gcm` | `git checkout $(git_main_branch)` | 切到 main |
| `gcd` | `git checkout $(git_develop_branch)` | 切到 develop（**不是** cd） |
| `gsw` | `git switch` | 較新的指令，只負責切換分支 |
| `gswc` | `git switch -c` | 建立並切換到新分支 |
| `gswm` | `git switch $(git_main_branch)` | 切到 main |
| `gswd` | `git switch $(git_develop_branch)` | 切到 develop |

## cherry-pick

| Alias | 指令 | 說明 |
|---|---|---|
| `gcp` | `git cherry-pick` | 把指定的 commit 複製到目前分支 |
| `gcpa` | `git cherry-pick --abort` | 中止 |
| `gcpc` | `git cherry-pick --continue` | 繼續（解完衝突後使用） |

## clone / clean

| Alias | 指令 | 說明 |
|---|---|---|
| `gcl` | `git clone --recurse-submodules` | clone，連 submodule 一起抓 |
| `gclf` | `git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules` | 快速 clone：先不下載檔案內容、需要時才抓，submodule 也是淺層的，適合大型 repo |
| `gccd` | `git clone --recurse-submodules ... && cd ...` | clone 完自動 cd 進新目錄 |
| `gclean` | `git clean --interactive -d` | **互動式**刪除未追蹤的檔案和目錄 |

## commit

| Alias | 指令 | 說明 |
|---|---|---|
| `gc` | `git commit --verbose` | 編輯器裡會顯示 diff，寫訊息時可以邊看邊確認 |
| `gca` | `git commit --verbose --all` | 自動暫存所有**已追蹤**檔案的變更（不含新檔案） |
| `gcam` | `git commit --all --message` | `gcam "msg"`：一步完成已追蹤變更的 commit |
| `gcmsg` | `git commit --message` | `gcmsg "msg"`：只提交已暫存的內容 |
| `gcn` | `git commit --verbose --no-edit` | 直接使用預設訊息（例如 merge commit 的訊息），不開編輯器 |
| `gc!` | `git commit --verbose --amend` | ⚠️ 用暫存區的內容修改（amend）上一個 commit，並編輯訊息 |
| `gcn!` | `git commit --verbose --no-edit --amend` | ⚠️ 用暫存區的內容 amend，**保留原訊息**（「忘記加檔案」的標準解法） |
| `gca!` | `git commit --verbose --all --amend` | ⚠️ 用所有已追蹤變更 amend，並編輯訊息 |
| `gcan!` | `git commit --verbose --all --no-edit --amend` | ⚠️ 用所有已追蹤變更 amend，保留原訊息 |
| `gcans!` | `git commit --verbose --all --signoff --no-edit --amend` | ⚠️ 同上，再加上 `Signed-off-by` |
| `gcann!` | `git commit --verbose --all --date=now --no-edit --amend` | ⚠️ 同 `gcan!`，再**把 commit 日期改成現在** |
| `gcas` | `git commit --all --signoff` | `-a` 加 signoff（加上 `Signed-off-by:` 一行） |
| `gcasm` | `git commit --all --signoff --message` | `-a` 加 signoff 加訊息 |
| `gcsm` | `git commit --signoff --message` | signoff 加訊息 |
| `gcs` | `git commit -S` | 用 GPG 簽署 commit |
| `gcss` | `git commit -S -s` | GPG 簽署加 signoff |
| `gcssm` | `git commit -S -s -m` | GPG 簽署加 signoff 加訊息 |
| `gcfu` | `git commit --fixup` | `gcfu <sha>`：為指定 commit 建立 `fixup!` commit，搭配 `grbmia` 可以自動合併進去 |

## describe / diff

| Alias | 指令 | 說明 |
|---|---|---|
| `gdct` | `git describe --tags $(git rev-list --tags --max-count=1)` | 顯示最新的 tag 名稱 |
| `gd` | `git diff` | 工作目錄 vs 暫存區（尚未暫存的變更） |
| `gdca` | `git diff --cached` | 暫存區 vs HEAD（即將被 commit 的內容） |
| `gds` | `git diff --staged` | 同 `gdca` |
| `gdw` | `git diff --word-diff` | 同 `gd`，但以「字」為單位標示差異 |
| `gdcw` | `git diff --cached --word-diff` | 同 `gdca`，但以「字」為單位標示差異 |
| `gdv` | `git diff -w`，交給 `view -` | 忽略空白的 diff，用 vim 唯讀模式開啟 |
| `gdup` | `git diff @{upstream}` | 你的工作目錄 vs 遠端追蹤分支 |
| `gdnolock` | `git diff ":(exclude)package-lock.json" ":(exclude)*.lock"` | diff 時排除 lock 檔 |
| `gdt` | `git diff-tree --no-commit-id --name-only -r` | `gdt <sha>`：列出該 commit 改了哪些檔案 |

## fetch

| Alias | 指令 | 說明 |
|---|---|---|
| `gf` | `git fetch` | fetch |
| `gfa` | `git fetch --all --tags --prune` | 抓取所有遠端和 tag，並清掉遠端已刪除的分支 |
| `gfo` | `git fetch origin` | 只抓 origin |

## GUI

| Alias | 指令 | 說明 |
|---|---|---|
| `gg` | `git gui citool` | 開啟 git gui 進行 commit |
| `gga` | `git gui citool --amend` | 以 amend 模式開啟 git gui |
| `gk` | `gitk --all --branches &!` | 在背景開啟 gitk，顯示所有分支 |
| `gke` | `gitk --all $(git log --walk-reflogs --pretty=%h) &!` | gitk，連只能從 reflog 找到的 commit 也一起顯示，適合找回遺失的 commit |

## log

`glol` 系列的彩色格式是：hash、分支/tag 標籤、訊息、時間、作者。

| Alias | 指令 | 說明 |
|---|---|---|
| `glo` | `git log --oneline --decorate` | 每個 commit 一行，附分支和 tag 標籤 |
| `glog` | `git log --oneline --decorate --graph` | `glo` 加上分支圖 |
| `gloga` | `git log --oneline --decorate --graph --all` | `glog`，涵蓋**所有分支** |
| `glgg` | `git log --graph` | 完整格式的分支圖 |
| `glgga` | `git log --graph --decorate --all` | 完整格式分支圖，所有分支，附標籤 |
| `glgm` | `git log --graph --max-count=10` | 分支圖，只顯示最近 10 筆 |
| `glol` | `git log --graph --pretty=<彩色格式，相對時間>` | 彩色分支圖，時間顯示為 3 days ago 這類**相對時間** |
| `glola` | `glol` 加 `--all` | `glol`，涵蓋所有分支 |
| `glols` | `glol` 加 `--stat` | `glol` 加上每個 commit 改動的檔案清單 |
| `glolm` | `git log $(git_main_branch)` 加 `glol` 格式 | main 分支的 `glol` |
| `glod` | `git log --graph --pretty=<彩色格式，絕對日期>` | 同 `glol`，但顯示**絕對日期** |
| `glods` | `glod` 加 `--date=short` | `glod`，日期用短格式（YYYY-MM-DD） |
| `glom` | `git log --oneline --decorate --color $(git_main_branch)..` | 目前分支上**還沒進 main** 的 commit |
| `glp` | `git log --pretty=<format>` | `glp <fmt>`：用指定格式顯示 log，例如 `glp oneline` |
| `glg` | `git log --stat` | log 加上每個 commit 的檔案變更統計 |
| `glgp` | `git log --stat --patch` | log 加統計加完整 diff |
| `gwch` | `git log --patch --abbrev-commit --pretty=medium --raw` | 「改了什麼」（what changed）：log 加 patch 加 raw 檔案變更 |

## ls-files / update-index

| Alias | 指令 | 說明 |
|---|---|---|
| `gfg` | `git ls-files`，交給 `grep` | `gfg <pattern>`：在已追蹤的檔案清單中搜尋符合的檔名 |
| `gignore` | `git update-index --assume-unchanged` | 把檔案標記為 assume-unchanged，git 就不再理會你在本地的修改（適合本地設定檔） |
| `gunignore` | `git update-index --no-assume-unchanged` | 取消上述標記 |
| `gignored` | `git ls-files -v`，篩出小寫開頭的行 | 列出被 `gignore` 標記的檔案。**不是** `.gitignore` 排除的那些檔案 |

## merge

| Alias | 指令 | 說明 |
|---|---|---|
| `gm` | `git merge` | merge |
| `gma` | `git merge --abort` | 中止 |
| `gmc` | `git merge --continue` | 繼續 |
| `gms` | `git merge --squash` | 把變更放進暫存區，之後還要自己 commit |
| `gmff` | `git merge --ff-only` | 只允許 fast-forward 合併，否則拒絕 |
| `gmom` | `git merge origin/$(git_main_branch)` | 把 `origin/main` 合併進目前分支 |
| `gmum` | `git merge upstream/$(git_main_branch)` | 把 `upstream/main` 合併進目前分支（fork 工作流程） |
| `gmtl` | `git mergetool --no-prompt` | 開啟 mergetool，不用每次都確認 |
| `gmtlvim` | `git mergetool --no-prompt --tool=vimdiff` | 用 vimdiff 解決衝突 |

## pull

| Alias | 指令 | 說明 |
|---|---|---|
| `gl` | `git pull` | pull |
| `gpr` | `git pull --rebase` | 把你的 commit 接在遠端的 commit 後面，不產生 merge commit |
| `gprv` | `git pull --rebase -v` | `gpr`，輸出詳細資訊 |
| `gpra` | `git pull --rebase --autostash` | `gpr` 加 autostash：先自動 stash 未提交的變更，完成後再還原 |
| `gprav` | `git pull --rebase --autostash -v` | `gpra`，輸出詳細資訊 |
| `gprom` | `git pull --rebase origin $(git_main_branch)` | 從 `origin/main` 以 rebase 方式 pull |
| `gpromi` | `git pull --rebase=interactive origin $(git_main_branch)` | 同上，但用互動式 rebase |
| `gprum` | `git pull --rebase upstream $(git_main_branch)` | 從 `upstream/main` 以 rebase 方式 pull |
| `gprumi` | `git pull --rebase=interactive upstream $(git_main_branch)` | 同上，但用互動式 rebase |
| `ggpull` | `git pull origin "$(git_current_branch)"` | pull origin 上的**同名分支** |
| `ggl` | `git pull origin $(current_branch)` | 同 `ggpull`，也可以帶分支名稱當參數 |
| `ggpur` | `ggu` | 以 rebase 方式 pull origin 的同名分支 |
| `gluc` | `git pull upstream $(git_current_branch)` | pull upstream 的同名分支 |
| `glum` | `git pull upstream $(git_main_branch)` | pull upstream 的 main（同步 fork） |

## push

| Alias | 指令 | 說明 |
|---|---|---|
| `gp` | `git push` | push |
| `gpd` | `git push --dry-run` | 顯示會推送什麼，但不實際推送 |
| `gpv` | `git push --verbose` | 輸出詳細資訊的 push |
| `gpsup` | `git push --set-upstream origin $(git_current_branch)` | **新分支第一次 push**：push 並設定 upstream |
| `gpsupf` | `gpsup` 加 `--force-with-lease --force-if-includes` | 同上，加上安全的 force push |
| `gpf` | `git push --force-with-lease --force-if-includes` | 安全的 force push，別人在你之後推過就會拒絕（Git < 2.30 沒有 `--force-if-includes`） |
| `gpf!` | `git push --force` | ⚠️ 不管怎樣都覆蓋遠端 |
| `ggp` | `git push origin $(current_branch)` | 把目前分支推到 origin 的同名分支 |
| `ggpush` | `git push origin "$(git_current_branch)"` | 同 `ggp` |
| `ggf` | `git push --force origin $(current_branch)` | ⚠️ 把目前分支 force push 到 origin |
| `ggfl` | `git push --force-with-lease origin $(current_branch)` | 用 force-with-lease 把目前分支推到 origin |
| `ggpnp` | `ggl && ggp` | 先 pull 再 push |
| `gpoat` | `git push origin --all && git push origin --tags` | 把所有分支和所有 tag 推到 origin |
| `gpod` | `git push origin --delete` | `gpod <branch>`：刪除**遠端**的該分支 |
| `gpu` | `git push upstream` | 推到名為 `upstream` 的遠端 |

## rebase

| Alias | 指令 | 說明 |
|---|---|---|
| `grb` | `git rebase` | rebase |
| `grba` | `git rebase --abort` | 中止 |
| `grbc` | `git rebase --continue` | 繼續 |
| `grbs` | `git rebase --skip` | 跳過 |
| `grbi` | `git rebase --interactive` | 互動式 rebase（squash、調整順序、修改 commit） |
| `grbm` | `git rebase $(git_main_branch)` | rebase 到 main 上 |
| `grbd` | `git rebase $(git_develop_branch)` | rebase 到 develop 上 |
| `grbom` | `git rebase origin/$(git_main_branch)` | rebase 到 `origin/main` 上 |
| `grbum` | `git rebase upstream/$(git_main_branch)` | rebase 到 `upstream/main` 上 |
| `grbmi` | `git rebase $(git_main_branch) --interactive` | 互動式 rebase 到 main 上 |
| `grbmia` | `git rebase $(git_main_branch) --interactive --autosquash` | `grbmi` 加 autosquash：用 `gcfu` 建立的 `fixup!` commit 會自動合併進目標 commit |
| `grbo` | `git rebase --onto` | 把分支的一部分搬到別的基底上 |

## reflog / remote

| Alias | 指令 | 說明 |
|---|---|---|
| `grf` | `git reflog` | HEAD 移動過的歷史紀錄。reset 錯了之後救回 commit 的救命繩 |
| `gr` | `git remote` | 列出遠端 |
| `grv` | `git remote --verbose` | 列出遠端與 URL |
| `gra` | `git remote add` | 新增遠端 |
| `grrm` | `git remote remove` | 移除遠端 |
| `grmv` | `git remote rename` | 重新命名遠端 |
| `grset` | `git remote set-url` | 修改遠端 URL |
| `grup` | `git remote update` | 從所有遠端抓取更新 |

## reset / restore（⚠️ 這一區要特別小心）

| Alias | 指令 | 說明 |
|---|---|---|
| `grh` | `git reset` | mixed reset：取消暫存，但變更保留在檔案裡 |
| `gru` | `git reset --` | `gru <file>`：取消暫存單一檔案 |
| `grhs` | `git reset --soft` | 移動 HEAD，變更保留在暫存區。`grhs HEAD~1` = 撤銷上一個 commit |
| `grhk` | `git reset --keep` | 移動 HEAD 但保留本地變更，有衝突時會拒絕執行 |
| `grhh` | `git reset --hard` | ⚠️ **丟棄**所有未提交的變更 |
| `groh` | `git reset origin/$(git_current_branch) --hard` | ⚠️ 丟棄本地 commit 和變更，讓本地完全等同遠端 |
| `gwipe` | `git reset --hard && git clean --force -df` | ⚠️ hard reset 加刪除未追蹤檔案（保留被 ignore 的檔案） |
| `gpristine` | `git reset --hard && git clean --force -dfx` | ⚠️⚠️ hard reset 加刪除未追蹤**和被 ignore** 的檔案，回到剛 clone 下來的狀態。`.env`、`node_modules`、建置產物全部會被刪掉 |
| `grs` | `git restore` | `grs <file>`：丟棄該檔案在工作目錄的修改 |
| `grss` | `git restore --source` | `grss <sha> <file>`：從指定 commit 還原某個檔案 |
| `grst` | `git restore --staged` | `grst <file>`：取消暫存（新語法） |

## revert / rm

| Alias | 指令 | 說明 |
|---|---|---|
| `grev` | `git revert` | 建立一個新 commit 來抵銷指定 commit（不改寫歷史） |
| `greva` | `git revert --abort` | 中止 |
| `grevc` | `git revert --continue` | 繼續 |
| `grm` | `git rm` | 刪除檔案並把刪除加入暫存區 |
| `grmc` | `git rm --cached` | `grmc <file>`：停止追蹤檔案，但保留在磁碟上（例如不小心 commit 進去的 `.env`） |

## shortlog / show

| Alias | 指令 | 說明 |
|---|---|---|
| `gcount` | `git shortlog --summary -n` | 依作者統計 commit 數量，並排序 |
| `gsh` | `git show` | 顯示某個 commit 的內容 |
| `gsps` | `git show --pretty=short --show-signature` | 用短格式顯示 commit，並驗證 GPG 簽章 |

## stash

| Alias | 指令 | 說明 |
|---|---|---|
| `gsta` | `git stash push` | 把已追蹤檔案的變更收起來（Git < 2.13 用 `git stash save`） |
| `gstu` | `git stash --include-untracked` | 連未追蹤的檔案一起收 |
| `gstall` | `git stash --all` | 全部都收，包含被 ignore 的檔案 |
| `gstl` | `git stash list` | 列出所有 stash |
| `gsts` | `git stash show --patch` | 用 diff 顯示 stash 的內容 |
| `gstp` | `git stash pop` | 套用並從清單中移除 |
| `gstaa` | `git stash apply` | 套用但**保留**在清單中 |
| `gstd` | `git stash drop` | 刪除一個 stash |
| `gstc` | `git stash clear` | ⚠️ 刪除**所有** stash |

## status

| Alias | 指令 | 說明 |
|---|---|---|
| `gst` | `git status` | status |
| `gss` | `git status --short` | 短格式 |
| `gsb` | `git status --short -b` | 短格式加分支名稱與 ahead/behind 數量 |
| `gsnut` | `git status --untracked-files=no` | 不顯示未追蹤的檔案 |

## submodule / svn

| Alias | 指令 | 說明 |
|---|---|---|
| `gsi` | `git submodule init` | 初始化 submodule |
| `gsu` | `git submodule update` | 更新 submodule |
| `gsuri` | `git submodule update --recursive --init` | 遞迴初始化並更新所有 submodule（clone 完先跑這個） |
| `gsd` | `git svn dcommit` | 把 commit 推到 SVN |
| `gsr` | `git svn rebase` | 拉取 SVN 上的新變更 |
| `git-svn-dcommit-push` | `git svn dcommit && git push github $(git_main_branch):svntrunk` | 推到 SVN 後，再把 main 推到 `github` 遠端的 `svntrunk` 分支（特定工作流程專用） |

## tag

| Alias | 指令 | 說明 |
|---|---|---|
| `gta` | `git tag --annotate` | 建立 annotated tag |
| `gts` | `git tag -s` | 建立 GPG 簽署的 tag |
| `gtv` | `git tag`，交給 `sort -V` | 依版本號排序列出 tag |
| `gtl` | `git tag --sort=-v:refname -n --list <prefix>*` | `gtl <prefix>`：列出以該前綴開頭的 tag，最新版本排最前面，附上 tag 說明 |

## worktree

| Alias | 指令 | 說明 |
|---|---|---|
| `gwt` | `git worktree` | worktree |
| `gwta` | `git worktree add` | 新增 worktree，可以在另一個目錄 checkout 別的分支 |
| `gwtls` | `git worktree list` | 列出 worktree |
| `gwtmv` | `git worktree move` | 移動 worktree |
| `gwtrm` | `git worktree remove` | 移除 worktree |

## WIP（快速暫停手邊的工作）

| Alias / 函式 | 說明 |
|---|---|
| `gwip` | 把所有變更加入暫存區，建立標題為 `--wip-- [skip ci]` 的暫時 commit，略過 hooks 和 GPG |
| `gunwip` | 如果最後一個 commit 是 WIP commit，就撤銷它，把變更放回工作目錄 |
| `gunwipall` | 撤銷最近所有連續的 `--wip--` commit |
| `work_in_progress` | 如果目前分支是 WIP 狀態，就印出警告 |

---

## 輔助函式

上面很多 alias 都靠這些函式決定分支名稱，也可以直接拿來用：

| 函式 | 說明 |
|---|---|
| `git_current_branch` | 回傳目前分支名稱 |
| `git_current_user_email` | 回傳 `user.email` 設定值 |
| `git_current_user_name` | 回傳 `user.name` 設定值 |
| `git_main_branch` | 回傳 main 分支名稱：有 `main` 就是 `main`，否則是 `master` |
| `git_develop_branch` | 回傳 develop 分支名稱：依序找 `dev`、`devel`、`development`，都沒有就是 `develop` |
| `gbcopy` | 把目前分支名稱複製到剪貼簿 |
| `grename <old> <new>` | 重新命名分支，origin 上的也一起改 |
| `gbda` | 刪除所有已合併的分支 |
| `gbds` | 刪除所有 squash merge 過的分支（分支越多越慢） |

## 改過名稱的 alias

習慣舊用法的人容易踩到：

| Alias | 舊意思 | 現在的意思 | 舊功能改用 |
|---|---|---|---|
| `gap` | `git add --patch` | `git apply` | `gapa` |
| `gcl` | `git config --list` | `git clone --recurse-submodules` | `gcf` |
| `gdt` | `git difftool` | `git diff-tree ...` | 無替代 |
