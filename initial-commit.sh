#!/bin/bash
# 映话 (Yinghua) · initial commit
# 用法：cd <repo> && bash initial-commit.sh

set -e
cd "$(dirname "$0")"

echo "=== Initializing git ==="
git init
git branch -M main

echo "=== Adding files ==="
git add .gitignore
git add README.md LICENSE CONTRIBUTING.md CODE_OF_CONDUCT.md SECURITY.md
git add GOVERNANCE.md MAINTAINERS.md ARCHITECTURE.md STYLE.md ROADMAP.md
git add design/
git add code/
git add .github/

echo "=== Verifying nothing is missed ==="
git status --short | head -50

echo ""
echo "=== Committing ==="
git commit -m "feat: initial public release

映话 (Yinghua / Yìnghuà) — local-first meeting intelligence for Mac.

Includes:
- D1 v2.0 design system (16 章) + D2 117 design tokens
- macOS app (SwiftUI + AppKit) with audio capture, transcription, AI summary, BYOK
- iOS companion app (SwiftUI + iOS 18) with SharedKit
- Chrome extension (Manifest v3) with panel, VU meter, export
- Marketing website (3 locales) with Cloudflare Pages deploy ready
- 5 App Store screenshots, 9 investor deck pages, 20+ social templates
- Privacy + ToS (GDPR / CCPA / COPPA)
- CI/CD (GitHub Actions build / release / extension)
- Code signing + notarization
- Crash reporting (opt-in)
- 3rd party integrations (Notion / Slack / Webhook)
- Apple Shortcuts integration
- 14+ independent verifier audit verdicts

Closes: v0.1.0 public beta"

echo ""
echo "=== Done. Next steps: ==="
echo "  1. Create GitHub repo: gh repo create yinghua-inc/yinghua --public --source=. --remote=upstream"
echo "  2. Or manually: git remote add origin git@github.com:yinghua-inc/yinghua.git"
echo "  3. Push: git push -u origin main"
echo "  4. Create first release: git tag v0.1.0 && git push origin v0.1.0"
