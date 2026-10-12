#!/bin/zsh
set -e
cd "$(dirname "$0")"
./build.sh
pkill -x Hotbar 2>/dev/null && sleep 0.5 || true
mkdir -p ~/Applications
rm -rf ~/Applications/Hotbar.app
cp -R build/Hotbar.app ~/Applications/
open ~/Applications/Hotbar.app
echo "Installed to ~/Applications/Hotbar.app"
