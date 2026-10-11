# Neovim / LazyVim 按鍵筆記

這套設定使用 **LazyVim**。大部分 Vim 操作仍維持原樣，差異主要來自 Flash、Yanky、Dial、FZF、LSP 等外掛。

- `<Leader>`：`Space`
- `<LocalLeader>`：反斜線 `\`
- `<Space>?`：顯示目前 buffer 的可用按鍵
- `<Space>sk`：搜尋所有 keymap

## 保留 Vim 原意的按鍵

| 類別 | 按鍵 | 功能 |
| --- | --- | --- |
| 基本移動 | `h`、`l` | 左、右 |
| 單字移動 | `w/W`、`b/B`、`e/E` | 下一單字、上一單字、單字尾 |
| 行內移動 | `0`、`^`、`$` | 行首、第一個非空白字元、行尾 |
| 文件移動 | `gg`、`G` | 文件開頭、文件結尾 |
| 字元搜尋 | `f/F`、`t/T`、`;`、`,` | 行內尋找字元及重複搜尋 |
| 配對跳轉 | `%` | 跳到括號、標籤等配對位置 |
| 段落移動 | `{`、`}` | 上一段落、下一段落 |
| 插入 | `i/I`、`a/A` | 在游標前後或行首尾插入 |
| 新增行 | `o/O` | 在下方或上方新增一行 |
| 刪除 | `x/X`、`d`、`dd`、`D` | 刪除字元、範圍、整行或至行尾 |
| 修改 | `c`、`cc`、`C` | 修改範圍、整行或至行尾 |
| 取代 | `r`、`R` | 取代單一字元或進入 Replace mode |
| 合併 | `J` | 合併下一行 |
| Visual | `v`、`V`、`Ctrl-v` | 字元、行、區塊選取 |
| 搜尋 | `/`、`?`、`*`、`#` | 搜尋文字或游標下的單字 |
| Undo | `u`、`Ctrl-r` | 復原、重做 |
| 重複 | `.` | 重複最後一次修改 |
| 巨集 | `q{register}`、`@{register}` | 錄製、執行巨集 |
| 標記 | `m{letter}`、`'`、反引號 | 設定及跳到 mark |
| 跳轉歷史 | `Ctrl-o`、`Ctrl-i` | 上一個、下一個跳轉位置 |
| 摺疊 | `za`、`zo`、`zc` | 切換、展開、關閉 fold |
| 視窗 | `Ctrl-w` 開頭的命令 | Vim 原有的視窗管理命令 |
| 命令列 | `:` | 執行 Ex command |

## 相同語意，但功能被加強

| 按鍵 | LazyVim 行為 | 與 Vim 的差異 |
| --- | --- | --- |
| `j`、`k` | 沿畫面顯示行上下移動 | 長行換行時使用 `gj/gk`；輸入次數如 `5j` 時仍走實際行 |
| `y` | Yanky 複製 | 加入短暫高亮、剪貼歷史及系統剪貼簿同步 |
| `p`、`P` | Yanky 貼上 | 保留原意，但可循環過去的複製內容 |
| `[y`、`]y` | 切換 yank history | 貼上後可改用前一筆或下一筆複製內容 |
| `<Space>p` | 開啟 yank history | 搜尋並選擇過去複製的內容 |
| `n`、`N` | 下一個、上一個搜尋結果 | 跳到結果時會自動展開 fold |
| `Esc` | 回到 Normal mode | 同時清除搜尋高亮並停止 snippet |
| `Ctrl-a`、`Ctrl-x` | Dial 增加、減少 | 支援數字、日期、月份、星期、布林值、Markdown checkbox、版本號等 |
| Visual `>`、`<` | 增減縮排 | 縮排後仍保留選取，可連續操作 |
| `Ctrl-f`、`Ctrl-b` | 向前、向後翻頁 | 有 LSP/Noice 浮動視窗時先捲動浮窗，否則維持 Vim 行為 |
| Insert `Tab`、`Shift-Tab` | snippet 跳轉 | 沒有活動 snippet 時仍是一般 Tab |
| `gc{motion}` | 註解或取消註解 | 例如 `gcc` 切換目前行，`gcip` 切換段落 |
| `gco`、`gcO` | 新增註解行 | 在目前行下方或上方加入註解 |

## 被重新指定的 Vim 按鍵

| 按鍵 | 現在的功能 | 傳統 Vim 功能或替代方式 |
| --- | --- | --- |
| `s` | Flash 跳轉 | 原本是刪除一個字元並插入；改用 `cl` |
| `S` | Flash Treesitter，以語法節點跳轉或選取 | 原本是修改整行；改用 `cc` |
| `H` | 上一個 buffer | Vim 原本跳到畫面頂部 |
| `L` | 下一個 buffer | Vim 原本跳到畫面底部 |
| `Space` | `<Leader>` 前綴 | Vim 原本等同向右移動 |
| `K` | LSP hover，顯示型別或文件 | LSP attach 時覆寫；原生 `K` 可用 `<Space>K` |
| `gd` | LSP definition | 跳到定義 |
| `gr` | LSP references | 傳統 Vim 的 `gr` 功能會被 LSP 映射取代 |
| `Ctrl-h/j/k/l` | 切換左、下、上、右視窗 | 省略原生的 `Ctrl-w` 前綴 |

## Flash 跳轉

基本使用流程：

```text
s → 輸入目標附近的文字 → 按畫面顯示的標籤
```

例如畫面中有多個 `function`，可以輸入：

```text
sfu
```

Flash 會替匹配位置顯示標籤，按下標籤即可跳轉。它也可用於 Visual 和 operator-pending mode，例如先按 `d`，再以 `s` 選擇刪除目標。

| 按鍵 | 模式 | 功能 |
| --- | --- | --- |
| `s` | Normal、Visual、Operator | 一般 Flash 搜尋跳轉 |
| `S` | Normal、Visual、Operator | 依 Treesitter 語法節點跳轉 |
| `r` | Operator-pending | Remote Flash |
| `R` | Visual、Operator-pending | Treesitter Search |
| `Ctrl-Space` | Normal、Visual、Operator | 漸進式選取 Treesitter 節點 |
| Command-line `Ctrl-s` | 搜尋命令列 | 開關 Flash 搜尋標籤 |

## 新增的移動與編輯功能

| 按鍵 | 功能 |
| --- | --- |
| `Ctrl-h/j/k/l` | 移動到相鄰視窗 |
| `Ctrl-方向鍵` | 調整視窗大小 |
| `Alt-j`、`Alt-k` | 向下、向上移動目前行或 Visual 選取內容 |
| `[b`、`]b` | 上一個、下一個 buffer |
| `H`、`L` | 上一個、下一個 buffer |
| `[d`、`]d` | 上一個、下一個 diagnostic |
| `[e`、`]e` | 上一個、下一個 error |
| `[w`、`]w` | 上一個、下一個 warning |
| `[h`、`]h` | 上一個、下一個 Git hunk |
| `[t`、`]t` | 上一個、下一個 TODO |
| `[f`、`]f` | 上一個、下一個 function |
| `[c`、`]c` | 上一個、下一個 class |
| `[a`、`]a` | 上一個、下一個 parameter |
| `Ctrl-s` | 儲存檔案；在 Insert mode 使用會回到 Normal mode |
| `Ctrl-/` | 開關浮動 terminal |

> 在 macOS 終端中，`Alt-j/k` 通常是 `Option-j/k`。如果沒有反應，需要確認終端是否將 Option 傳送為 Alt/Meta。

## 常用 Leader 功能

以下按鍵皆以 `Space` 開頭。

### 檔案與搜尋

| 按鍵 | 功能 |
| --- | --- |
| `<Space><Space>` | 尋找專案檔案 |
| `<Space>e` | 開啟專案檔案瀏覽器 |
| `<Space>,` | 切換 buffer |
| `<Space>/` | 全專案文字搜尋 |
| `<Space>ff` | 尋找專案根目錄的檔案 |
| `<Space>fF` | 尋找目前目錄的檔案 |
| `<Space>fr` | 最近開啟的檔案 |
| `<Space>sg` | 搜尋專案文字 |
| `<Space>sG` | 搜尋目前目錄文字 |
| `<Space>ss` | 尋找目前檔案的 symbol |
| `<Space>sS` | 尋找整個 workspace 的 symbol |
| `<Space>sk` | 搜尋所有 keymap |

### 程式碼與診斷

| 按鍵 | 功能 |
| --- | --- |
| `<Space>cf` | 格式化程式碼 |
| `<Space>ca` | LSP Code Action |
| `<Space>cr` | 重新命名 symbol |
| `<Space>cd` | 顯示目前行 diagnostics |
| `<Space>xx` | 開關所有 diagnostics 列表 |
| `<Space>xX` | 開關目前 buffer 的 diagnostics 列表 |
| `<Space>cs` | 顯示文件 symbols |
| `<Space>cS` | 顯示 LSP references、definitions 等資訊 |

### Buffer、視窗與終端

| 按鍵 | 功能 |
| --- | --- |
| `<Space>bd` | 刪除目前 buffer |
| `<Space>bo` | 刪除其他 buffer |
| `<Space>bb` | 切換到上一個使用的 buffer |
| `<Space>-` | 水平分割視窗 |
| `<Space>` + &#124; | 垂直分割視窗 |
| `<Space>wd` | 關閉目前視窗 |
| `<Space>ft` | 開啟專案根目錄 terminal |
| `<Space>fT` | 開啟目前目錄 terminal |

### Git 與其他功能

| 按鍵 | 功能 |
| --- | --- |
| `<Space>gg` | 開啟專案根目錄的 Lazygit |
| `<Space>gG` | 開啟目前目錄的 Lazygit |
| `<Space>gb` | 顯示目前行的 Git blame |
| `<Space>gl` | Git log |
| `<Space>gf` | 目前檔案的 Git history |
| `<Space>qq` | 關閉 Neovim |
| `<Space>l` | 開啟 Lazy 外掛管理器 |
| `<Space>?` | 顯示目前 buffer 的可用按鍵 |

## LSP 按鍵

這些按鍵只會在相應的 Language Server 已連線且支援該功能時生效。

| 按鍵 | 功能 |
| --- | --- |
| `gd` | 跳到 definition |
| `gD` | 跳到 declaration |
| `gr` | 尋找 references |
| `gI` | 跳到 implementation |
| `gy` | 跳到 type definition |
| `K` | 顯示 hover 文件 |
| `gK` | 顯示 function signature |
| Insert `Ctrl-k` | 顯示 function signature |
| `<Space>ca` | Code Action |
| `<Space>cr` | 重新命名 symbol |
| `<Space>cR` | 重新命名檔案 |
| `[[`、`]]` | 上一個、下一個 reference |

## Dashboard 專用按鍵

下列按鍵只在 Neovim 啟動畫面生效，不會覆寫一般編輯畫面的 Vim 操作。

| 按鍵 | 功能 |
| --- | --- |
| `f` | Find file |
| `r` | Recent files |
| `g` | Find text |
| `c` | 開啟 Neovim 設定檔 |
| `x` | Lazy Extras |
| `l` | Lazy 外掛管理器 |
| `q` | 離開 Neovim |

## 查詢按鍵的方法

```vim
:map s
:verbose map s
:nmap
:vmap
:imap
```

- `<Space>`：等待 WhichKey 顯示可用群組。
- `<Space>?`：查看目前 buffer 的按鍵。
- `<Space>sk`：透過 FZF 搜尋所有 keymap。
- `:verbose map {按鍵}`：查看按鍵最後由哪個設定或外掛定義。
