# Marcos

<img src="assets/app-icon.png" width="160" alt="Glasses with a charcoal frame, one clear lens and one red lens">

A small native macOS menu bar app that adds an adjustable red tint to your screens.

- Left-click the glasses in the menu bar to toggle the filter.
- Right-click or Control-click to open options, adjust strength, or quit.
- Red glasses indicate an active tint. Clear glasses indicate the tint is off.
- Settings are saved automatically.
- Launches at login after first opening. If macOS requires approval, use **Open Login Items** in the options.

## Build and install

Requires macOS 13 or later and the Xcode command line tools. The build targets the architecture of the Mac running it.

```sh
git clone https://github.com/perezpaya/marcos.git
cd marcos
./build.sh
ditto "build/Marcos.app" "$HOME/Applications/Marcos.app"
open "$HOME/Applications/Marcos.app"
```

The build uses Swift, AppKit, SwiftUI, and ServiceManagement. It signs the app locally with an ad-hoc signature. The app uses click-through overlay windows on connected displays and follows desktop Spaces and full-screen apps. Turning it off or quitting removes the overlays. A strength of 0% applies no tint.

The filter adds a red tint and dims the image. Maximum strength is capped to preserve readability. Results depend on the display and content. It starts after you log in, and the filter is off on first launch.

## Verify

Run in a logged-in macOS desktop session. These checks briefly toggle the filter and create faint overlays, then remove them.

```sh
xcrun swiftc -warnings-as-errors FilterController.swift StatusMenu.swift FilterControllerTest.swift -o /tmp/MarcosChecks
/tmp/MarcosChecks
```

The checks cover the left-click action, filter state, saved settings, strength changes, display reconfiguration, and menu icon states.

## Icon

The app icon has a neutral frame with one clear lens and one red lens. It was generated using OpenAI's built-in image generation tool. The generation prompt is in [assets/icon-prompt.txt](assets/icon-prompt.txt), the original PNG is in [assets/app-icon.png](assets/app-icon.png), and the macOS icon is in [assets/Marcos.icns](assets/Marcos.icns).

## License

MIT. See [LICENSE](LICENSE).
