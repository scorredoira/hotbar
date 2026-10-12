#!/bin/zsh
set -e
cd "$(dirname "$0")"
swift build -c release
APP=build/Hotbar.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp .build/release/Hotbar "$APP/Contents/MacOS/Hotbar"
cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleIdentifier</key><string>com.scorredoira.hotbar</string>
  <key>CFBundleName</key><string>Hotbar</string>
  <key>CFBundleExecutable</key><string>Hotbar</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>0.1</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSMinimumSystemVersion</key><string>14.0</string>
  <key>LSUIElement</key><true/>
  <key>NSPrincipalClass</key><string>NSApplication</string>
</dict>
</plist>
PLIST
IDENTITY="${HOTBAR_SIGN_IDENTITY:-$(security find-identity -v -p codesigning | awk -F'"' '/Apple Development/ {print $2; exit}')}"
codesign --force --sign "${IDENTITY:--}" "$APP"
echo "$APP"
