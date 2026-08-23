# C74 — GitHub Actions 自动 deploy 报告

> 接手时间：2026-08-23 11:35 EDT
> Worker session：`mvs_37a1d4714e4e431fa88658166647d06c`
> 父 session：`mvs_4f13d64598fd4b129a1bc6f60c5b25e1`
> 状态：**✅ Files committed & pushed** · 等 owner 加 secrets 后 deploy 自动跑

---

## 一句话总结

C72 因为 Cloudflare token 的 IP allowlist 挡住了本机出口 IP，wrangler
直连 deploy 走不通。C74 改用 GitHub Actions 跑 `cloudflare/pages-action@v1`：
- 修了 `wrangler.toml`（删 `[build]` 和 `[vars]` 两个 Pages 不支持的 section）
- 建了 2 个 workflow（production + PR preview）
- 改了 `README.md` 和 `.github/SECRETS.md` 加 deploy 文档
- 全部 commit + push 到 `upstream main` ✅
- **owner 需在 GitHub repo 加 2 个 secret** 后 deploy 才会自动跑

---

## 1. wrangler.toml 修改

### 1.1 修改前（C72 留下）

```toml
name = "yinghua-marketing"  # Cloudflare Pages project name
compatibility_date = "2026-08-01"
pages_build_output_dir = "./public"

[build]                           # ← Pages 项目不支持
command = "echo 'No build step needed - static HTML'"

[vars]                            # ← Pages 项目 wrangler.toml 不支持
# 自定义域 (在 Cloudflare Dashboard 配,这里仅注释)
# Domain: yinghua.zzw4257.cn
# CNAME @ -> yinghua-marketing.pages.dev (Cloudflare 自动)
# CNAME www -> yinghua-marketing.pages.dev

CLOUDFLARE_PAGES_BRANCH = "main"
```

**问题**（C72 §4 已识别）：
- `[build]` 是 Workers-only，Pages 不识别 → wrangler 报
  `Configuration file for Pages projects does not support "build"`
- `[vars]` 在 Pages 项目的 wrangler.toml 里也不支持（应该用 Dashboard
  Environment Variables 配）

### 1.2 修改后（C74 当前）

```toml
name = "yinghua-marketing"
compatibility_date = "2026-08-01"
pages_build_output_dir = "./public"

# Custom domain (yinghua.zzw4257.cn) is configured in Cloudflare Dashboard
# under Pages project → Custom domains, not here. CNAME @ → yinghua-marketing.pages.dev
# is auto-created by Cloudflare once the custom domain is attached.
#
# For GitHub Actions deployment (see .github/workflows/deploy-pages.yml):
#   - CLOUDFLARE_API_TOKEN (no IP allowlist, Pages:Edit + Account Settings:Read)
#   - CLOUDFLARE_ACCOUNT_ID = a802c5b7499e1f9e2259a295823d853d
#
# Note: [build] and [vars] sections were removed — they are Workers-only
# and not supported by Pages. The previous C29/C72 wrangler.toml incorrectly
# included both. See C72 report §4 and C74 deploy-report.md for details.
```

**diff**：
- ➖ 删除 `[build]` section（含 `command` 一行）
- ➖ 删除 `[vars]` section（含注释 + `CLOUDFLARE_PAGES_BRANCH` 一行）
- ➕ 顶部加 8 行注释，说明 custom domain 和 GitHub Actions 配置位置

---

## 2. 2 个 GitHub Actions workflow

### 2.1 `.github/workflows/deploy-pages.yml` — Production

| 字段 | 值 |
|------|----|
| **触发** | `push` 到 `main`（路径 filter：C29/C39/deploy/workflow）+ `workflow_dispatch`（手动） |
| **Runner** | `ubuntu-latest` · `timeout-minutes: 10` |
| **构建** | `cp` C29 website/ → 根 + `cp` C39 ja-JP/ → `/ja-JP/` + `cp` `_redirects` `_headers`（如存在）|
| **部署** | `cloudflare/pages-action@v1` → project `yinghua-marketing` |
| **Branch** | 默认 `main`（workflow_dispatch 选 preview 时切到 `preview` 分支）|
| **权限** | `contents: read` + `deployments: write` |
| **Concurrency** | `pages-production` / `pages-preview` group，cancel-in-progress |

**关键步骤**：

```yaml
- name: Build deploy bundle
  run: |
    set -euo pipefail
    BUILD=/tmp/yinghua-pages
    rm -rf "$BUILD"
    mkdir -p "$BUILD"
    # 根（zh-Hans）从 C29
    cp -r design/_exploration/C29_marketing-website/website/. "$BUILD/"
    # ja-JP 子目录从 C39
    mkdir -p "$BUILD/ja-JP"
    cp -r design/_exploration/C39_website-i18n/ja-JP/. "$BUILD/ja-JP/"
    # _redirects / _headers（可选，存在才 cp）
    for f in _redirects _headers; do
      if [ -f "design/_exploration/C29_marketing-website/deploy/public/$f" ]; then
        cp "design/_exploration/C29_marketing-website/deploy/public/$f" "$BUILD/"
      fi
    done
    # 验证 bundle
    echo "HTML count: $(find "$BUILD" -name '*.html' | wc -l | tr -d ' ')"
    echo "Total size: $(du -sh "$BUILD" | cut -f1)"

- name: Deploy to Cloudflare Pages
  uses: cloudflare/pages-action@v1
  with:
    apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
    accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
    projectName: yinghua-marketing
    directory: /tmp/yinghua-pages
    branch: ${{ github.event.inputs.environment == 'preview' && 'preview' || 'main' }}
    gitHubToken: ${{ secrets.GITHUB_TOKEN }}
```

**为什么根用 C29 而不是 C39 zh-Hans？** 实测 `C29_marketing-website/website/index.html`
`<html lang="zh-Hans">`，**C29 实际就是中文版**，C39 zh-Hans/ 是重复的拷贝。根用
C29 即可。

### 2.2 `.github/workflows/deploy-pages-preview.yml` — PR Preview

| 字段 | 值 |
|------|----|
| **触发** | `pull_request` 到 `main`（同样路径 filter）|
| **Runner** | `ubuntu-latest` · `timeout-minutes: 10` |
| **构建** | 同上（同一份打包逻辑）|
| **部署** | `cloudflare/pages-action@v1` → project `yinghua-marketing` |
| **Branch** | 固定 `preview`（每个 PR 共用同一 preview 分支，latest-wins）|
| **权限** | `contents: read` + `pull-requests: write` + `deployments: write` |
| **Concurrency** | `pages-preview-${{ github.event.pull_request.number }}`，cancel-in-progress |

**关键差别**：
- 没有 `workflow_dispatch`（PR 自动触发）
- `branch: preview`（force preview 分支，与 production 隔离）
- 多 `pull-requests: write` 权限（让 action 能在 PR 上 comment 预览 URL）

---

## 3. 文档更新

### 3.1 `README.md`（root）

加了 3 处内容（English + 简体中文 两版同步）：

1. **CI/CD 表格** 新增 2 行：
   - `Deploy Pages` — push to main (website paths) + manual
   - `Preview Pages` — PR (website paths)
2. **secret 总数** 从 "4 必配 + 4 可选" 改成 "4 必配 + 4 可选 + 2 必配"
3. **新增 §Deployment 章节**：
   - 解释 2 个 workflow 各自干什么
   - 解释为什么不用本地 wrangler（C72 IP-blocked）
   - 列出 2 个必配 secret 表
   - 链到 `.github/SECRETS.md` 详细配置

### 3.2 `.github/SECRETS.md`

加了 3 处内容：

1. **新增 §9 `CLOUDFLARE_API_TOKEN`**（6 步生成指南 + C72 教训 + 安全注意）
2. **新增 §10 `CLOUDFLARE_ACCOUNT_ID`**（含硬编码值 `a802c5b7499e1f9e2259a295823d853d`）
3. **新增 §Cloudflare Pages Setup**（owner 一次性操作 5 步：create project / add custom domain / 验证上传 / 配 secrets / 触发第一次 deploy）
4. **轮换策略表** 新增 2 行（CF token 1 年/泄漏；CF account_id 几乎不变）

---

## 4. Git push 结果

### 4.1 准备 commit

只 add C74 任务范围内的文件，**不**碰其他 C 任务的 working tree 改动：

```bash
git add .github/workflows/deploy-pages.yml
git add .github/workflows/deploy-pages-preview.yml
git add .github/SECRETS.md
git add README.md
git add design/_exploration/C29_marketing-website/deploy/wrangler.toml
git add design/_exploration/C74_github-actions-deploy/deploy-report.md
```

未 add（属于其他 task）：
- `code/yinghua-extension/manifest.json` (M)
- `design/_exploration/C68_integration-tests/run-all-tests.sh` (M)
- `design/_exploration/C64..C73, C76/` 整个目录树（untracked，由其他 task 负责）

### 4.2 Commit + push

见下节"实际执行"。

---

## 5. Owner 必做：配 2 个 GitHub secret

> ⚠️ **不配这 2 个 secret，deploy workflow 会在 `Deploy to Cloudflare Pages`
> 步骤失败**（HTTP 401）。配完才自动跑。

### 5.1 `CLOUDFLARE_API_TOKEN`

**配置位置**：`https://github.com/zzw4257/yinghua/settings/secrets/actions` → **New repository secret**

**值生成步骤**：

1. 打开 <https://dash.cloudflare.com/profile/api-tokens>
2. **Create Token** → 模板 **Edit Cloudflare Pages**
3. **Account Resources**：`Include → zzw4257 account`
4. **Zone Resources**：Include → Specific zone → `yinghua.zzw4257.cn`（如果 zone 在 CF）
5. **Permissions**：
   - `Account → Account Settings: Read`
   - `Account → Cloudflare Pages: Edit`
6. **IP Address Filtering**：**留空**（**关键** —— C72 就是栽在这里）
7. **TTL**：选 No expiration 或 1 year
8. **Create Token** → 复制（**只显示一次**）

**C72 教训**：C72 用的旧 token 配了 IP allowlist，**且** Pages:Edit 权限缺失，
所以从 worker 本机调任何 API 都 401/403。如果 C74 的新 token 也失败，
**第一件事**就是去 Dashboard 确认 IP filtering 留空。

### 5.2 `CLOUDFLARE_ACCOUNT_ID`

**配置位置**：同上

**值**：`a802c5b7499e1f9e2259a295823d853d`

**验证**：在 <https://dash.cloudflare.com/> 右下角 **API** 卡片的 **Account ID** 字段应一致。

---

## 6. 部署触发流程

```
[developer 改文件]
  ↓
git commit + git push upstream main
  ↓
GitHub 收到 push，触发 .github/workflows/deploy-pages.yml
  ↓
[Step 1] actions/checkout@v4 拉代码
  ↓
[Step 2] Build deploy bundle
  - cp C29 website/ → /tmp/yinghua-pages/  (zh-Hans 根)
  - cp C39 ja-JP/   → /tmp/yinghua-pages/ja-JP/  (日文子目录)
  - cp _redirects _headers (从 deploy/public，如存在)
  - verify：打印 HTML 数量 + 总体积
  ↓
[Step 3] cloudflare/pages-action@v1
  - 用 ${{ secrets.CLOUDFLARE_API_TOKEN }} 鉴权
  - PUT /accounts/{id}/pages/projects/yinghua-marketing/deployments
  - 上传 /tmp/yinghua-pages/ 内容到 main 分支
  ↓
[Done] Cloudflare Pages dashboard 显示新 deployment
  - URL: https://yinghua-marketing.pages.dev/
  - 自定义域: https://yinghua.zzw4257.cn/  (DNS + SSL 自动)
```

**预估总时长**：2-4 分钟（其中 1-2 分钟在 Cloudflare 端处理 + 边缘节点同步）。

---

## 7. 验收 vs 实际

| 验收项 | 状态 |
|--------|------|
| ✅ wrangler.toml 改成 Pages 格式（删 `[build]` + `[vars]`） | ✅ Done |
| ✅ `.github/workflows/deploy-pages.yml` 创建 | ✅ Done |
| ✅ `.github/workflows/deploy-pages-preview.yml` 创建 | ✅ Done |
| ✅ README.md 加 deployment 章节 | ✅ Done (EN + 简中 两版) |
| ✅ .github/SECRETS.md 加 CF token 章节 | ✅ Done (§9 §10 + setup + 轮换) |
| ✅ git commit + push 到 zzw4257/yinghua | ✅ 见 §8 |
| ✅ deploy-report.md 写好 | ✅ 本文件 |

**没真跑 deploy**（按任务要求：CF token IP 受限 → 等 owner 配新 token）。

---

## 8. 实际执行

> 这节是事后填的（push 完成后），确保 C74 报告自包含。

### 8.1 git add（仅 C74 文件）

```bash
$ cd /Users/zzw4257/Documents/ZJU_archieve/08-AI之路/2026-8-Interview-dragon
$ git add .github/workflows/deploy-pages.yml \
           .github/workflows/deploy-pages-preview.yml \
           .github/SECRETS.md \
           README.md \
           design/_exploration/C29_marketing-website/deploy/wrangler.toml \
           design/_exploration/C74_github-actions-deploy/deploy-report.md

$ git status --short
 M code/yinghua-extension/manifest.json                          # 其他 task，未碰
 M design/_exploration/C68_integration-tests/run-all-tests.sh    # 其他 task，未碰
M  .github/SECRETS.md                                            # C74
A  .github/workflows/deploy-pages-preview.yml                    # C74
A  .github/workflows/deploy-pages.yml                            # C74
M  README.md                                                     # C74
A  design/_exploration/C74_github-actions-deploy/deploy-report.md # C74
M  design/_exploration/C29_marketing-website/deploy/wrangler.toml # C74
?? design/_exploration/C64..C73, C75, C76/                       # 其他 task，未碰
```

### 8.2 git commit

```
$ git commit -m "ci: add Cloudflare Pages deploy via GitHub Actions + fix wrangler.toml ..."
[main 3147a0e] ci: add Cloudflare Pages deploy via GitHub Actions + fix wrangler.toml
 6 files changed, 688 insertions(+), 13 deletions(-)
 create mode 100644 .github/workflows/deploy-pages-preview.yml
 create mode 100644 .github/workflows/deploy-pages.yml
 create mode 100644 design/_exploration/C74_github-actions-deploy/deploy-report.md
```

### 8.3 git push

```
$ git push upstream main
To github.com:zzw4257/yinghua.git
   6c82f8b..3147a0e  main -> main
```

### 8.4 git log 确认

```
$ git log --oneline -3
3147a0e ci: add Cloudflare Pages deploy via GitHub Actions + fix wrangler.toml
6c82f8b feat: initial public release
```

✅ Commit `3147a0e` 已在 `zzw4257/yinghua` 的 `main` 分支上。owner 现在去配 2 个 secret 就能触发第一次 deploy。

---

## 9. 下一步建议（给 owner）

1. **现在**：去 `https://github.com/zzw4257/yinghua/settings/secrets/actions` 加 2 个 secret
   - `CLOUDFLARE_API_TOKEN`（按 §5.1 生成，**IP filtering 留空**）
   - `CLOUDFLARE_ACCOUNT_ID` = `a802c5b7499e1f9e2259a295823d853d`
2. **首次**：在 Cloudflare Dashboard 手动创建 `yinghua-marketing` Pages project
   （GitHub Actions 只负责上传，不会建项目）
3. **首次**：Pages project → **Custom domains** 加 `yinghua.zzw4257.cn` + `www.yinghua.zzw4257.cn`
4. **验证**：触发一次空 commit 看 deploy workflow 跑通，访问 <https://yinghua.zzw4257.cn/> 验
5. **后续**：push 到 main 即自动 deploy；PR 即自动 preview

详细 owner 一次性操作见 `.github/SECRETS.md` §Cloudflare Pages Setup。

---

**报告完成时间**：2026-08-23 11:35 EDT
**报告人**：Worker agent (Mavis) · session `mvs_37a1d4714e4e431fa88658166647d06c`
