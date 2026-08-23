.PHONY: all build test archive notarize clean release help

# Self-locating: runnable from any cwd
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PROJECT_ROOT := $(abspath $(MAKEFILE_DIR)/../../..)
CODE_DIR     := $(PROJECT_ROOT)/code/Yinghua
SIGN_SCRIPT  := $(MAKEFILE_DIR)sign-and-notarize.sh

all: build

# Quick dev build
build:
	cd $(CODE_DIR) && xcodegen generate
	cd $(CODE_DIR) && xcodebuild -project Yinghua.xcodeproj -scheme Yinghua -configuration Debug build

# Test build
test:
	cd $(CODE_DIR) && xcodebuild test -project Yinghua.xcodeproj -scheme Yinghua -destination 'platform=macOS'

# Archive for App Store
archive:
	cd $(CODE_DIR) && xcodegen generate
	cd $(CODE_DIR) && xcodebuild -project Yinghua.xcodeproj -scheme Yinghua -configuration Release clean archive -archivePath build/Yinghua.xcarchive

# Notarize (需要 DEVELOPMENT_TEAM_ID 环境变量)
notarize:
	bash $(SIGN_SCRIPT)

# Full release pipeline
release: archive notarize
	@echo "✅ Release done."

# Clean
clean:
	cd $(CODE_DIR) && xcodebuild -project Yinghua.xcodeproj clean
	rm -rf build/

# Help
help:
	@echo "Targets: build / test / archive / notarize / release / clean"
	@echo "Usage:  make -f design/_exploration/C33_code-signing/Makefile release DEVELOPMENT_TEAM_ID=ABC123XYZ"
