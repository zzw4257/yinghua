#!/bin/bash
# 映话 macOS app · code sign + notarize
# 用法：DEVELOPMENT_TEAM_ID=ABC123XYZ ./sign-and-notarize.sh
set -euo pipefail

# 配置
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
SCHEME="Yinghua"
CONFIG="Release"
ARCHIVE_PATH="$PROJECT_DIR/build/Yinghua.xcarchive"
EXPORT_PATH="$PROJECT_DIR/build/Yinghua-export"
NOTARYTOOL_PROFILE="yinghua-notarytool"  # 来自 keychain
BUNDLE_ID="app.yinghua.Yinghua"

# 0. 前置检查
if [[ -z "${DEVELOPMENT_TEAM_ID:-}" ]]; then
    echo "❌ DEVELOPMENT_TEAM_ID 未设置。"
    echo "   用法：DEVELOPMENT_TEAM_ID=ABC123XYZ $0"
    exit 1
fi

cd "$PROJECT_DIR/code/Yinghua"

# Step 1: 确认环境
echo "=== Environment check ==="
xcodebuild -version
xcrun notarytool --version

# Step 2: 生成 xcodeproj
echo "=== xcodegen ==="
xcodegen generate

# Step 3: 清理
echo "=== xcodebuild clean ==="
xcodebuild -project Yinghua.xcodeproj -scheme "$SCHEME" -configuration "$CONFIG" clean

# Step 4: Archive
echo "=== xcodebuild archive ==="
xcodebuild \
    -project Yinghua.xcodeproj \
    -scheme "$SCHEME" \
    -configuration "$CONFIG" \
    -destination 'platform=macOS' \
    -archivePath "$ARCHIVE_PATH" \
    DEVELOPMENT_TEAM="$DEVELOPMENT_TEAM_ID" \
    CODE_SIGN_STYLE=Automatic \
    CODE_SIGN_IDENTITY="Apple Distribution" \
    archive

# Step 5: 导出 .pkg
echo "=== xcodebuild -exportArchive ==="
EXPORT_PLIST=/tmp/yinghua-export.plist
cat > "$EXPORT_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>$DEVELOPMENT_TEAM_ID</string>
    <key>uploadSymbols</key>
    <true/>
</dict>
</plist>
EOF

xcodebuild \
    -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_PATH" \
    -exportOptionsPlist "$EXPORT_PLIST"

# Step 6: Notarize .pkg
echo "=== xcrun notarytool submit ==="
NOTARIZE_ZIP_PATH="$EXPORT_PATH/notarize.zip"
ditto -c -k --sequesterRsrc --keepParent "$EXPORT_PATH/Yinghua.app" "$NOTARIZE_ZIP_PATH"

xcrun notarytool submit "$NOTARIZE_ZIP_PATH" \
    --keychain-profile "$NOTARYTOOL_PROFILE" \
    --wait

# Step 7: Staple
echo "=== xcrun stapler staple ==="
xcrun stapler staple "$EXPORT_PATH/Yinghua.app"
xcrun stapler validate "$EXPORT_PATH/Yinghua.app"

# Step 8: 验证
echo "=== Verification ==="
codesign -dvv "$EXPORT_PATH/Yinghua.app"
spctl -a -vv "$EXPORT_PATH/Yinghua.app"

echo "✅ Build + sign + notarize + staple done. Output: $EXPORT_PATH/Yinghua.app"
