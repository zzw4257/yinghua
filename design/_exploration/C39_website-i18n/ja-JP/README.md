# C39 — Marketing Website i18n (ja-JP)

> **映話（えいわ / Yinghua）公式マーケティングサイト · 日本語版** · 静的サイト · HTML / CSS / JS
> ステータス：v1 · 2026-08-24 · C39 多言語化（zh-Hans + ja-JP）
> ソースサイト：[`../../C29_marketing-website/website/`](../../C29_marketing-website/website/)（CSS / JS / 画像資産を共有）
> デザイン仕様：[`../../design-doc.md`](../../design-doc.md) v2.0 (16 章) + [`../../design-tokens.json`](../../design-tokens.json) (117 token)
> トーン：ダーク + ライトのデュアルテーマ · Apple の抑制 · 紫青ブランドカラー · ガラス面

---

## 📦 ファイル一覧

```
ja-JP/
├── index.html              # ホーム（5 セクションのアンカースクロール + Footer）· lang="ja-JP"
├── features.html           # 詳細機能ページ（4 大機能の解説 + プライバシー）· lang="ja-JP"
├── pricing.html            # 詳細料金ページ（3 ティアカード + 比較表 + FAQ）· lang="ja-JP"
├── download.html           # ダウンロードページ（macOS App Store + システム要件 + 既知の問題 + checksum）· lang="ja-JP"
├── privacy.html            # プライバシーポリシー（11 章の正式版）· lang="ja-JP"
├── terms.html              # 利用規約（14 章の正式版）· lang="ja-JP"
└── README.md               # 本ファイル
```

> **資産の再利用**：本ディレクトリの 6 つの HTML はすべて C29 の共有リソースを参照しています（`../C29_marketing-website/website/assets/...`）：
> - `assets/css/main.css` · メインスタイルシート
> - `assets/js/main.js` · テーマ切替 + スムーズスクロール + nav アクティブ + FAQ トグル
> - `assets/img/*.png` · Hero、icon、5 枚の App Store スクリーンショット
> - `favicon.png` · サイトアイコン
>
> つまり CSS / JS / 画像の単一更新源は引き続き C29 にあり、**C39 はこれらのリソースを複製しません**。

---

## 🈯 文言規範

### 翻訳ルール

- **視覚要素はそのまま**（画像 / カラー / レイアウト / フォント参照）
- **テキストコンテンツのみ翻訳**（見出し / 段落 / ボタン / ラベル）
- **技術用語は英語のまま保持**：API、BYOK、macOS、SwiftUI、Anthropic、OpenAI、Keychain、Whisper
- **翻訳しないもの**：
  - ファイル名 / クラス名 / パス
  - "Yinghua Inc."（会社实体名）
  - "Yinghua"（製品の英語名）
  - `yinghua.zzw4257.cn` ドメイン
  - メールアドレス（`team@yinghua.app` など）
  - 数字（そのまま）
  - 通貨記号（¥、$）

### 主要文言

| 項目 | ja-JP 値 |
|------|----------|
| メインタイトル | 映話 |
| サブタイトル | 面接のための macOS スマートアシスタント |
| メイン CTA | macOS を無料ダウンロード |
| セカンダリ CTA | プレビューを見る / チームプランを見る / 14 日間無料トライアルを開始 |
| コアラベル | リアルタイム文字起こし / AI 要約 / ローカル優先 / BYOK |
| ブランド二段組 | 映話 · Yinghua |
| 副題ローマ字 | エイワ · Yinghua |
| 価格 | Free ¥0 永久 / Pro $19 月 / Team $49 シート月 |
| 通貨 | ¥（日本円） / $（米ドル） |

> **ブランド名の読み**：日本語では「映話」を **エイワ (Eiwa)** と読みます。英語併記の「Yinghua」はそのまま、ナビ・フッター・OGP では中国語漢字「映話」を視覚的アンカーとして使用します。

---

## 🎨 フォント

- **日本語見出し**：`Noto Serif JP`（400-700）
- **日本語本文**：`Noto Sans JP`（400-600）
- **英語見出し**：`Inter Tight`（500-800）+ `Inter Display` フォールバック
- **英語本文**：`Inter`（400-700）
- **等幅**：`JetBrains Mono`（タイムコード / メタデータ / microcopy）
- **導入**：Google Fonts `<link>` + システムフォールバック（`SF Pro Display` / `Hiragino Mincho ProN` / `Hiragino Kaku Gothic ProN`）

> **CSS フォントのオーバーライド**：共有 CSS は `Noto Serif SC` / `Noto Sans SC` をフォールバックとして優先しています。本 ja-JP 版では、各 HTML の `<head>` に以下のインライン `<style>` を追加し、Noto Serif/Sans **JP** を優先させています：
> ```html
> <style>
>   html[lang="ja-JP"] {
>     --font-display: 'Noto Serif JP', 'Inter Display', 'SF Pro Display', 'Hiragino Mincho ProN', system-ui, serif;
>     --font-text: 'Noto Sans JP', 'Inter', 'SF Pro Text', 'Hiragino Kaku Gothic ProN', system-ui, -apple-system, sans-serif;
>     --font-serif-zh: 'Noto Serif JP', 'Yu Mincho', 'Hiragino Mincho ProN', serif;
>     --font-sans-zh: 'Noto Sans JP', 'Hiragino Kaku Gothic ProN', sans-serif;
>   }
> </style>
> ```

Google Fonts URL:
```
https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Inter+Tight:wght@500;600;700;800&family=JetBrains+Mono:wght@400;500&family=Noto+Sans+JP:wght@400;500;600&family=Noto+Serif+JP:wght@400;500;600;700&display=swap
```

---

## 🚀 ローカル開発

```bash
# ソースサイトディレクトリに入る
cd design/_exploration/C29_marketing-website/website

# ローカルサーバーを起動（Python 3）
python3 -m http.server 8000

# ブラウザでアクセス
# 中国語版：http://localhost:8000/../../C39_website-i18n/zh-Hans/index.html
# 日本語版：http://localhost:8000/../../C39_website-i18n/ja-JP/index.html
```

または C39 ルートディレクトリでサーバーを起動する簡単版：

```bash
cd design/_exploration/C39_website-i18n
python3 -m http.server 8001
# 中国語版：http://localhost:8001/zh-Hans/index.html
# 日本語版：http://localhost:8001/ja-JP/index.html
```

### ローカルテストの推奨チェックリスト

1. ✅ 6 ページがすべて正常に表示される
2. ✅ 相対パスがすべて正しく解決される（`../C29_marketing-website/website/...`）
3. ✅ CSS ロードが正常、フォントフォールバックが機能、ダーク / ライト切替が動作
4. ✅ 4 つのブレークポイントをテスト（1440 / 1024 / 768 / 375）
5. ✅ 5 枚の製品スクリーンショットがすべてロードされる
6. ✅ モバイル nav 折りたたみメニュー
7. ✅ 日本語フォントが正しくレンダリングされる（Noto Serif JP / Noto Sans JP が CSS 変数オーバーライドで優先される）

---

## 🔗 C29 との関係

| 項目 | 処理 |
|------|------|
| **資産の所有権** | すべての CSS / JS / 画像は引き続き C29 に存在し、本ディレクトリは参照のみ |
| **HTML テンプレート** | 6 つの HTML は C29 と 1:1 対応（index / features / pricing / download / privacy / terms）|
| **テキストコンテンツ** | C29（中国語版）を日本語に翻訳。技術用語と固有名詞は保持 |
| **フォント** | Noto Serif JP / Noto Sans JP を優先（インライン CSS オーバーライドで実現）|
| **カラー / 間隔 / 角丸** | C29 → design-tokens.json → CSS カスタムプロパティをそのまま使用 |
| **構造変更** | なし（資産パスの相対参照化とフォントオーバーライドのみ）|

> **C29 が単一更新源**。CSS / JS / 画像を更新する必要がある場合は、直接 C29 を編集してください。本ディレクトリの HTML は自動的に新しいリソースを参照します。
> HTML コンテンツ（テキスト、レイアウト）を更新する場合は、C29 と本ディレクトリの 12 ファイル（zh-Hans + ja-JP）を同期して修正してください。

---

## 📝 他の言語バージョンとの関係

| 言語 | パス | 文字セット | 主要フォント |
|------|------|------------|-------------|
| 简体中文 | [`../zh-Hans/`](../zh-Hans/) | 簡体中文 | Noto Serif SC / Noto Sans SC |
| 日本語 | `ja-JP/`（本ディレクトリ）| 日本語 | Noto Serif JP / Noto Sans JP |
| English | 未提供 | 今後追加予定 | Inter / Inter Display |

---

## ✅ 検証チェックリスト

- [x] 6 つの HTML ページ（index / features / pricing / download / privacy / terms）
- [x] すべて `lang="ja-JP"`
- [x] フォント：Noto Serif JP（見出し）+ Noto Sans JP（本文）
- [x] ブランド：映話 · Yinghua（漢字 + 英語二段組）
- [x] メインタイトル：「映話」+ 副題ローマ字：「エイワ · Yinghua」
- [x] 技術用語を英語のまま保持：BYOK / API / macOS / SwiftUI / Anthropic / OpenAI / Keychain / Whisper
- [x] 翻訳しない：メール、ドメイン、ファイル名、会社实体名
- [x] C29 と 1:1 ビジュアルで対応
- [x] C29 資産パスがすべて有効
- [x] 日本語フォントオーバーライドが `<head>` に含まれる
- [x] README.md（本ファイル）が整備されている

---

**バージョン**：v1.0 · 2026-08-24
**License**：本プロジェクトのソースコードは MIT · スクリーンショットおよびデザイン資産は D1 §15 ライセンスに従う
