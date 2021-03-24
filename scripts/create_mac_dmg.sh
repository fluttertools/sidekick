#!/bin/sh
test -f sidekick.dmg && rm sidekick.dmg
create-dmg \
  --volname "Sidekick Installer" \
  --volicon "./assets/sidekick_installer.icns" \
  --background "./assets/dmg_background.png" \
  --window-pos 200 120 \
  --window-size 800 530 \
  --icon-size 130 \
  --text-size 14 \
  --icon "Sidekick.app" 260 250 \
  --hide-extension "Sidekick.app" \
  --app-drop-link 540 250 \
  --hdiutil-quiet \
  "build/macos/Build/Products/Release/Sidekick.dmg" \
  "build/macos/Build/Products/Release/Sidekick.app"