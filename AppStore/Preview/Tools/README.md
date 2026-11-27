# Rebuild the App Store screenshots

Run from the repository root in a logged-in macOS desktop session with Xcode command line tools installed.

```sh
xcrun swiftc -warnings-as-errors FilterController.swift StatusMenu.swift \
  AppStore/Preview/Tools/CaptureControls.swift -o /tmp/MarcosNativeCapture
/tmp/MarcosNativeCapture "$PWD" /tmp/marcos-native-captures
xcrun swift AppStore/Preview/Tools/RenderScreenshots.swift \
  /tmp/marcos-native-captures AppStore/Preview/Screenshots
xcrun swift AppStore/Preview/Tools/MakeContactSheet.swift AppStore/Preview
```

The harness instantiates the production `FilterControls` view with isolated temporary preferences and does not launch filters or change login settings. It renders native light/dark controls on explicit backgrounds. The renderer adds original surrounding artwork; desktop previews in images 2–5 are labeled illustrations using the production tint opacity formula. It does not retouch their native controls. The revised first image uses the saved AI-generated physical MacBook render in `../Assets/01-macbook-red-render.png`, including a controls inset based on the native capture. Rebuilding preserves this selected first image. Existing user preferences and the installed app are untouched.

All five screenshot exports must remain 2880 × 1800, RGB, sRGB, and opaque. `sips -g pixelWidth -g pixelHeight -g space -g hasAlpha -g profile AppStore/Preview/Screenshots/*.jpg` checks the output. Review every exported image visually after changes. `ContactSheet.jpg` and `index.html` are review assets, not App Store screenshots.

The user approved these screenshots, and all five were uploaded with version 1.2.3 on November 27, 2026. See [submission status](../BuildStatus.md).
