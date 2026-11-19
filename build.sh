#!/bin/bash
set -euo pipefail

source_dir="$(cd "$(dirname "$0")" && pwd)"
destination="${1:-$source_dir/build/Marcos.app}"
build_dir="$(mktemp -d)"
trap 'rm -rf "$build_dir"' EXIT
bundle="$build_dir/Marcos.app"

mkdir -p "$bundle/Contents/MacOS" "$bundle/Contents/Resources"
cp "$source_dir/Info.plist" "$bundle/Contents/Info.plist"
cp "$source_dir/assets/Marcos.icns" "$bundle/Contents/Resources/Marcos.icns"
cp "$source_dir/PrivacyInfo.xcprivacy" "$bundle/Contents/Resources/PrivacyInfo.xcprivacy"
xcrun swiftc -target "$(uname -m)-apple-macos13.0" -O -warnings-as-errors \
    "$source_dir/RedFilterApp.swift" "$source_dir/FilterController.swift" "$source_dir/StatusMenu.swift" \
    -o "$bundle/Contents/MacOS/RedFilter"
codesign --force --sign - "$bundle"
codesign --verify --strict "$bundle"
mkdir -p "$(dirname "$destination")"
ditto "$bundle" "$destination"
