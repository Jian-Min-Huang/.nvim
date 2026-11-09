# iPad 用 Rex 連 Mac Studio（經 iMac27 中轉）

## 背景

- Mac Studio 開著公司 VPN（Tunnelblick / OpenVPN，全流量），不能同時開 Tailscale.app。
- 以前的做法：iPad 用 Termius 的 Host Chaining（類似 SSH jump host），以 iMac27 當跳板連到 Mac Studio，再開 herdr。
- 現在改用 Rex。不過 iPad 的 Rex 只能連 Rex 網址，不能自己走 SSH，所以讓 iMac27 當中轉站。

## 架構

```
iPad Rex
   │  連 https://<imac27>.tail04ee51.ts.net   （走 Tailscale）
   ▼
iMac27
   │  ① Tailscale Serve：HTTPS 443 → 本機 127.0.0.1:7297
   │  ② SSH 隧道：本機 7297 → Mac Studio 的 Rex socket
   ▼
Mac Studio Rex（unix socket）
```

- iPad 不用 SSH，只負責連 iMac27 的 Tailscale 網址。
- Mac Studio 不用開 Tailscale，公司 VPN 照常開著。
- Rex 把連進來的 iPad 當成本機使用者（`uid 501 over unix`）。

## 各台機器的設定

### Mac Studio（192.168.0.43）

- 建了一個 socket 捷徑。原本的路徑有空格，SSH 指令不好寫：

  ```sh
  ln -sfn "$HOME/Library/Application Support/rex/server.sock" ~/.rex-server.sock
  ```

  隧道會用到這個捷徑，**不要刪除**。
- SSH 只接受金鑰登入，iMac27 的金鑰已經在 `authorized_keys` 裡。
- Rex 內建的 Tailscale 維持關閉（Settings › Server › Tailscale）。

### iMac27（192.168.0.44，有開 Tailscale）

- Tailscale Serve 設定一次就會常駐，重開機也會保留：

  ```sh
  tailscale serve --bg --https=443 http://127.0.0.1:7297
  tailscale serve status
  ```

- SSH 隧道目前是**手動開啟**，見下方「日常使用」。

### iPad

- 在 Rex › Settings › Remote Hosts 加入 `https://<imac27>.tail04ee51.ts.net`。
- iPad 的 Tailscale App 要保持 Connected。

## 日常使用

1. 在 iPad 用 Termius 連 iMac27。只連 iMac27 這台就好，不用走 Host Chaining 連到 Mac Studio。
2. 在 iMac27 開隧道。加 `-f` 讓 ssh 轉到背景執行，關掉 iPad 的 SSH 連線也不會斷：

   ```sh
   # Mac Studio 的金鑰、帳號、IP
   ssh -f -N -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -L 127.0.0.1:7297:/Users/yfr-mac-studio/.rex-server.sock -i <key> <user>@<ip>
   ```

3. 打開 iPad 的 Rex，連 iMac27 那個主機。

建議在 iMac27 的 `~/.zshrc` 把第 2 步設成 alias，例如 `rex-tunnel`。

## 檢查與排錯

能連到 Rex 時，`/api/control` 會回 `426`。從裡往外逐段測試，就能找出是哪一段斷了：

| 測哪一段 | 在哪台跑 | 指令 | 正常結果 |
| --- | --- | --- | --- |
| SSH 隧道 | iMac27 | `curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:7297/api/control` | `426` |
| Tailscale Serve | iMac27 | `curl -s -o /dev/null -w '%{http_code}\n' https://<imac27>.tail04ee51.ts.net/api/control` | `426` |
| iPad 是否連上 | Mac Studio | `rex client ls` | 出現 `iPad … uid 501 over unix` |

其他狀況：

- 關掉隧道：`pkill -f '7297:/Users/yfr-mac-studio/.rex-server.sock'`
- 第一次連 Tailscale Serve 時要申請 HTTPS 憑證，可能要等幾十秒。
- Mac Studio 的 IP 如果被 DHCP 換掉，隧道會連不上。可以在路由器把這個 IP 固定給 Mac Studio。

## 安全注意

- 經過隧道進來的連線，Rex 都當成本人，可以在 Mac Studio 執行任何指令。
- tailnet 上能連到 iMac27 的裝置，以及 iMac27 上的任何程式，都等於能完全操作 Mac Studio。
- tailnet 裡只有自己的裝置就沒問題。如果有別人的裝置，要用 Tailscale ACL 把 iMac27 的 443 埠限制給 iPad。

## 還原

| 要拿掉的部分 | 做法 |
| --- | --- |
| iMac27 的 Serve | `tailscale serve --https=443 off` |
| iMac27 的隧道 | 用上面的 `pkill` |
| Mac Studio 的捷徑 | `rm ~/.rex-server.sock` |
| iPad 的主機 | 在 Rex › Settings › Remote Hosts 刪除 |
