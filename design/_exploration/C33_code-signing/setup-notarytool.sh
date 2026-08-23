#!/bin/bash
# 一次性配置 notarytool keychain profile
# 用法：./setup-notarytool.sh
set -euo pipefail

read -p "Apple ID (email): " APPLE_ID
read -p "Team ID (10 chars): " TEAM_ID
read -p "App-specific password (from appleid.apple.com): " -s APP_PASSWORD
echo

# 创建 keychain 项
xcrun notarytool store-credentials "yinghua-notarytool" \
    --apple-id "$APPLE_ID" \
    --team-id "$TEAM_ID" \
    --password "$APP_PASSWORD"

echo "✅ Keychain profile 'yinghua-notarytool' saved. Future notarize uses this profile."
