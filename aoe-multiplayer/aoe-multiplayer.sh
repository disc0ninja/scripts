#!/bin/sh

echo "Getting aoe2 DE ready for multiplayer"

echo "moving to the right directory"

cd ~/.local/share/Steam/steamapps/compatdata/813780/pfx/drive_c/windows/system32

wget "https://aka.ms/vs/16/release/vc_redist.x64.exe"

cabextract vc_redist.x64.exe

cabextract a10

echo "May need to launch the game twice for multi-player support to work"

echo "Removing movie files"

rm -rf  ~/.local/share/Steam/steamapps/common/AoE2DE/resources/_common/movies

rm -rf ~/.local/share/Steam/steamapps/common/AoE2DE/resources/_common/en/campaign/movies

echo " That's it. Have fun!"

exit 0
