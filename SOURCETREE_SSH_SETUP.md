# macOS SourceTree：沿用 .gitconfig 的 SSH 金鑰設定

## 問題與原因

Terminal 可以存取 GitHub，但 SourceTree Fetch 出現：

```text
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.
```

本次診斷發現 SourceTree 在執行 Fetch 時注入：

```text
GIT_SSH_COMMAND=/usr/bin/ssh -o ConnectTimeout=300
```

這個環境變數的優先權高於 `.gitconfig` 的 `core.sshCommand`，因此原本透過 `-i` 指定的 SSH key 沒有生效。切換 System Git 本身並不足以解決問題。

修正方式是讓 SourceTree 透過一個小腳本啟動 Git：先移除 `GIT_SSH_COMMAND`，再把所有參數轉交給 `/usr/bin/git`。

```text
SourceTree
  → ~/.local/lib/sourcetree/git
  → 移除 GIT_SSH_COMMAND
  → /usr/bin/git
  → 依 .gitconfig / includeIf 載入 core.sshCommand
  → 使用對應的 SSH key
```

## 新電腦設定步驟

### 1. 準備原本的 Git 與 SSH 設定

先確認新 Mac 已備妥：

- SSH key，以及 GitHub 上對應的公鑰設定。
- `~/.ssh/config`。
- `~/.gitconfig` 與它引用的設定檔，例如 `~/.gitconfig-opennet`、`~/.gitconfig-personal`。
- 可執行的 `/usr/bin/git`。

在目標專案目錄確認 Git 能載入正確的 SSH 指令，且 Terminal 可以存取 repository：

```bash
git config --show-origin --get core.sshCommand
git ls-remote origin HEAD
```

這個修正不會建立金鑰或授予 GitHub repository 權限。

### 2. 切換 System Git 並關閉 SourceTree

在 **SourceTree → Settings／Preferences → Git → Use System Git** 選擇系統 Git。

接著按 **⌘Q 完全關閉 SourceTree**，再執行下面的設定命令。

### 3. 建立腳本並指定路徑

以下命令會建立或覆寫專用腳本，並更新 SourceTree 的自訂 Git 路徑：

```bash
mkdir -p "$HOME/.local/lib/sourcetree"

cat > "$HOME/.local/lib/sourcetree/git" <<'EOF'
#!/bin/sh
unset GIT_SSH_COMMAND
exec /usr/bin/git "$@"
EOF

chmod +x "$HOME/.local/lib/sourcetree/git"

defaults write com.torusknot.SourceTreeNotMAS \
  gitCustomPath -string "$HOME/.local/lib/sourcetree/git"
```

`<<'EOF'` 的單引號必須保留，讓 `"$@"` 原樣寫入腳本，等 SourceTree 呼叫時才展開為 Git 命令參數。

### 4. 確認並測試

確認 SourceTree 儲存的路徑：

```bash
defaults read com.torusknot.SourceTreeNotMAS gitCustomPath
```

預期結果：

```text
/Users/你的帳號/.local/lib/sourcetree/git
```

在目標專案目錄模擬 SourceTree 的 SSH 覆蓋，驗證腳本：

```bash
env GIT_SSH_COMMAND='/usr/bin/ssh -o ConnectTimeout=300' \
  "$HOME/.local/lib/sourcetree/git" ls-remote origin HEAD
```

成功時會輸出遠端 HEAD 的 commit hash。最後重新開啟 SourceTree，執行 **Fetch**，確認 App 也能正常使用。

## 使用注意事項

- SourceTree 畫面仍顯示 **System Git** 與真正 Git 的版本，因為腳本也會轉交版本查詢。
- 再次使用 **Use System Git** 選擇其他路徑，或切換 Embedded Git，可能取代目前的腳本設定。
- Terminal 原本的 Git 使用方式不變。
- 個人／工作帳號仍由原本 `.gitconfig` 的 `includeIf` 和 `core.sshCommand` 選擇。
- 本次曾測試在 SSH 設定加入 `ConnectTimeout 300`，但未能解決問題，已撤回；不需要加入這項設定。
- 此做法已在本次電腦驗證成功；SourceTree 更新後若再次出現問題，先檢查自訂 Git 路徑是否仍指向腳本。

## 還原

按 **⌘Q 關閉 SourceTree**，執行：

```bash
defaults write com.torusknot.SourceTreeNotMAS \
  gitCustomPath -string /usr/bin/git
```

重新開啟 SourceTree 後，就會直接使用系統 Git。腳本可保留，但不再被使用；原本的 SSH 覆蓋問題也可能再次出現。

## 參考

- [Git 官方文件：core.sshCommand 與 GIT_SSH_COMMAND 的優先權](https://git-scm.com/docs/git-config/2.44.3)
- [Atlassian 官方文件：切換 Embedded Git 與 System Git](https://support.atlassian.com/sourcetree/kb/using-embedded-git-or-system-git-in-sourcetree/)
