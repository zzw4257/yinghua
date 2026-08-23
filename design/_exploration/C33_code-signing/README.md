# 映话 Code Signing + Notarization

完整的 macOS 代码签名 + Apple 公证流水线，用于 Mac App Store 提交 + 用户 Gatekeeper 接受。

## 首次配置（一次性）

1. 注册 Apple Developer Program（$99/年）
2. 创建 App Store Connect app entry（bundle ID: `app.yinghua.Yinghua`）
3. 创建 App-specific password（[appleid.apple.com](https://appleid.apple.com) → App-Specific Passwords）
4. 跑 `./setup-notarytool.sh` 把凭证存到 keychain
5. 把 `DEVELOPMENT_TEAM_ID` 设为环境变量

## 日常发布

```bash
make release DEVELOPER_TEAM_ID=ABC123XYZ
```

## 步骤拆解

| 步骤 | 命令 | 说明 |
|------|------|------|
| 1 | `make build` | Debug 编译，跑测试 |
| 2 | `make test` | XCTest unit tests |
| 3 | `make archive` | Release 编译 + Archive |
| 4 | `make notarize` | 提交 Apple notary 服务 + staple + validate |
| 5 | `make clean` | 清理 build/ |

## 关键文件

- `code/Yinghua/project.yml` — xcodegen 配置（已含 signing）
- `code/Yinghua/Yinghua/Yinghua.entitlements` — sandbox exception
- `code/Yinghua/Yinghua/Info.plist` — usage descriptions
- `sign-and-notarize.sh` — 主脚本
- `setup-notarytool.sh` — 首次配置
- `Makefile` — 一键入口

## 故障排查

| 错误 | 原因 | 修法 |
|------|------|------|
| `No signing identity found` | Xcode 未登录 | Xcode → Settings → Apple ID → Login |
| `Profile doesn't include signing certificate` | 没有 Apple Distribution cert | developer.apple.com → Certificates → + |
| `notarytool submit failed: Authentication failed` | App-specific password 错 | 重新跑 `setup-notarytool.sh` |
| `stapler validate failed` | 苹果还没完成公证 | 等几分钟重跑 `stapler staple` |
