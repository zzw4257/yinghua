#!/bin/bash
# 映话 完整集成测试套件
# 用法：bash run-all-tests.sh

set -u
ROOT="/Users/zzw4257/Documents/ZJU_archieve/08-AI之路/2026-8-Interview-dragon"
REPORT="$ROOT/design/_exploration/C68_integration-tests/test-report.md"
PASS=0
FAIL=0
WARN=0

mkdir -p "$ROOT/design/_exploration/C68_integration-tests"

check() {
  local name="$1"
  local cmd="$2"
  if eval "$cmd" >/dev/null 2>&1; then
    echo "✅ $name"
    PASS=$((PASS+1))
  else
    echo "❌ $name"
    FAIL=$((FAIL+1))
  fi
}

echo "=== 映话 集成测试 ==="
echo ""

# 1. 文件结构
echo "## 1. 文件结构"
check "C22 design-doc v2.0 存在" "test -f $ROOT/design/design-doc.md"
check "D2 tokens 存在" "test -f $ROOT/design/design-tokens.json"
check "C10 矢量 icon SVG" "test -f $ROOT/design/_exploration/C10_vector-icon/icon-01-minimal__260823.svg"
check "C10 1024 PNG" "test -f $ROOT/design/_exploration/C10_vector-icon/icon-01-minimal-1024__260823.png"
check "C28 macOS .icns" "test -f $ROOT/design/_exploration/C28_mas-icon-icns/Yinghua.icns"
check "C24 iOS icon 3 SVG" "test -f $ROOT/design/_exploration/C24_ios-icon-set/icon-ios-01-minimal__260824.svg"
check "C23 5 App Store screenshots" "test -f $ROOT/design/_exploration/C23_app-store-screenshots/01-meeting__260824.png"
check "C15 dark 5 shippable" "test -f $ROOT/design/_exploration/C15_dark-shippable/01-meeting/product-meeting-in-progress__260824.jpg"
check "C16 light 5 shippable" "test -f $ROOT/design/_exploration/C16_light-shippable/05-onboarding/product-onboarding-light__260824.png"
check "C17 onboarding 3 屏" "test -f $ROOT/design/_exploration/C17_onboarding-shippable/03-byok/onboarding-03-byok__260824.jpg"
check "C18 marketing 6 张" "test -f $ROOT/design/_exploration/C18_marketing-landing/landing-hero-typography__260824.png"
check "C19 marketing 7 张" "test -f $ROOT/design/_exploration/C19_marketing-social/twitter-banner-3-1__260824.png"
check "C25 deck 9 张" "test -f $ROOT/design/_exploration/C25_investor-deck-full/deck-10-ask__260824.png"
check "C26 social 17 张" "test -f $ROOT/design/_exploration/C26_social-templates/twitter/twitter-launch__260824.jpg"

# 2. 代码
echo ""
echo "## 2. 代码"
check "C13 Yinghua macOS app" "test -d $ROOT/code/Yinghua"
check "C13 Yinghua.xcodeproj" "test -d $ROOT/code/Yinghua/Yinghua.xcodeproj"
check "C20 AudioCaptureService" "test -f $ROOT/code/Yinghua/Yinghua/Audio/AudioCaptureService.swift"
check "C20 SummaryService" "test -f $ROOT/code/Yinghua/Yinghua/API/SummaryService.swift"
check "C37 PrivacyInfo" "test -f $ROOT/code/Yinghua/Yinghua/PrivacyInfo.xcprivacy"
check "C21 Chrome ext manifest" "test -f $ROOT/code/yinghua-extension/manifest.json"
check "C21 background.js" "test -f $ROOT/code/yinghua-extension/background.js"
check "C38 iOS app project" "test -d $ROOT/code/Yinghua-ios"
check "C44 SharedKit Package.swift" "test -f $ROOT/code/SharedKit/Package.swift"
check "C40 .github workflow" "test -d $ROOT/.github/workflows"
check "C33 sign-and-notarize.sh" "test -f $ROOT/design/_exploration/C33_code-signing/sign-and-notarize.sh"

# 3. 文档
echo ""
echo "## 3. 文档"
check "C41 README 4 语言" "test -f $ROOT/README.md"
check "C41 LICENSE" "test -f $ROOT/LICENSE"
check "C41 CONTRIBUTING" "test -f $ROOT/CONTRIBUTING.md"
check "C41 CODE_OF_CONDUCT" "test -f $ROOT/CODE_OF_CONDUCT.md"
check "C41 SECURITY" "test -f $ROOT/SECURITY.md"
check "C27 brand guidelines" "test -f $ROOT/design/_exploration/C27_brand-guidelines/brand-guidelines__260824.md"
check "C27 GTM plan" "test -f $ROOT/design/_exploration/C27_brand-guidelines/gtm-plan__260824.md"
check "C30 App Store metadata" "test -f $ROOT/design/_exploration/C30_app-store-metadata/metadata-en.md"
check "C30 zh metadata" "test -f $ROOT/design/_exploration/C30_app-store-metadata/metadata-zh-Hans.md"
check "C31 Privacy" "test -f $ROOT/design/_exploration/C31_legal/privacy-policy.md"
check "C31 ToS" "test -f $ROOT/design/_exploration/C31_legal/terms-of-service.md"

# 4. 编译验证
echo ""
echo "## 4. 编译"
cd "$ROOT/code/Yinghua"
check "macOS app xcodegen" "xcodegen generate"
check "macOS app xcodebuild" "xcodebuild -project Yinghua.xcodeproj -scheme Yinghua -configuration Debug -destination 'platform=macOS' CODE_SIGN_IDENTITY='-' CODE_SIGNING_ALLOWED=NO build"
cd "$ROOT/code/SharedKit"
check "SharedKit macOS build" "swift build"
check "SharedKit iOS sim build" "xcodebuild -scheme YinghuaCore -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' build"
cd "$ROOT/code/yinghua-extension"
check "Chrome ext manifest JSON" "python3 -c \"import json; json.load(open('manifest.json'))\""
check "Chrome ext all JS syntax" "for f in *.js; do node --check \"\$f\" || exit 1; done"

# 5. Git
echo ""
echo "## 5. Git"
cd "$ROOT"
check "git init" "test -d .git"
check ".gitignore" "test -f .gitignore"
check "git has commits" "git log --oneline -1"
check "v0.1.0 tag" "git tag -l | grep -q v0.1.0"

# 6. 域名
echo ""
echo "## 6. 域名 (yinghua.zzw4257.cn)"
NON_EMAIL=$(grep -rn "yinghua.app" --include="*.md" --include="*.html" --include="*.swift" --include="*.json" --include="*.yml" --include="*.toml" --include="*.js" --include="*.css" "$ROOT" 2>/dev/null | grep -v "@yinghua.app" | grep -vE "(\.git/|build/|derivedData|\.app/|node_modules|/_audit-)" | wc -l | tr -d ' ')
if [ "$NON_EMAIL" = "0" ]; then
  echo "✅ yinghua.app 非邮箱引用 = 0"
  PASS=$((PASS+1))
else
  echo "❌ yinghua.app 非邮箱引用 = $NON_EMAIL"
  FAIL=$((FAIL+1))
fi
NEW_DOMAIN=$(grep -rn "yinghua.zzw4257.cn" --include="*.md" --include="*.html" --include="*.swift" --include="*.json" "$ROOT" 2>/dev/null | wc -l | tr -d ' ')
if [ "$NEW_DOMAIN" -gt "10" ]; then
  echo "✅ yinghua.zzw4257.cn 引用 = $NEW_DOMAIN (>$10)"
  PASS=$((PASS+1))
else
  echo "❌ yinghua.zzw4257.cn 引用 = $NEW_DOMAIN (<10)"
  FAIL=$((FAIL+1))
fi

# 总结
echo ""
echo "============================"
echo "PASS: $PASS"
echo "FAIL: $FAIL"
echo "============================"

# 写报告
cat > "$REPORT" << EOF
# 映话 集成测试报告

**测试时间**：$(date)
**测试环境**：macOS $(sw_vers -productVersion) / xcodebuild $(xcodebuild -version | head -1) / Python $(python3 --version | awk '{print $2}')

## 结果

- ✅ PASS: $PASS
- ❌ FAIL: $FAIL

## 测试类别
1. 文件结构 (14 项)
2. 代码 (11 项)
3. 文档 (10 项)
4. 编译 (5 项)
5. Git (4 项)
6. 域名 (2 项)

总计 **$((PASS+FAIL)) 项** · 失败率 **$(echo "scale=1; $FAIL*100/($PASS+$FAIL)" | bc)%**
EOF

if [ "$FAIL" = "0" ]; then
  echo "🎉 全部 PASS"
  exit 0
else
  echo "⚠️ 有 $FAIL 项失败"
  exit 1
fi
