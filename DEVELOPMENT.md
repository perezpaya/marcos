# Building Marcos

## Build from source

Requires macOS 13 or later and the Xcode command line tools. The build targets the architecture of the Mac running it.

```sh
git clone https://github.com/perezpaya/marcos.git
cd marcos
./build.sh
ditto "build/Marcos.app" "$HOME/Applications/Marcos.app"
open "$HOME/Applications/Marcos.app"
```

The build uses Swift, AppKit, SwiftUI, and ServiceManagement. It signs the app locally with an ad-hoc signature. The app uses click-through overlay windows on connected displays and follows desktop Spaces and full-screen apps. Turning it off or quitting removes the overlays. A strength of 0% applies no tint.

The filter adds a color tint and dims the image. Maximum strength is capped to preserve readability. Results depend on the display and content. It starts after you log in, and the filter is off on first launch.

## Verify

Run in a logged-in macOS desktop session. These checks briefly toggle the filter and create faint overlays, then remove them.

```sh
xcrun swiftc -warnings-as-errors FilterController.swift StatusMenu.swift FilterControllerTest.swift -o /tmp/MarcosChecks
/tmp/MarcosChecks
```

The checks cover the left-click action, filter state, saved settings and colors, zero-strength recovery, display reconfiguration, and menu icon states.

## Mac App Store preparation

Open `Marcos.xcodeproj` for the sandboxed universal Mac release target. The App Store release configuration, proposed listing, and signing instructions are in [AppStore/Submission.md](AppStore/Submission.md). Distribution signing, upload, and review are still pending.

Read the [privacy policy](PRIVACY.md).

## Icon assets

The app icon is an illustrated portrait with black glasses and red lenses, created from a user-provided face reference using OpenAI's built-in image generation tool. The generation prompt is in [assets/icon-prompt.txt](assets/icon-prompt.txt), the PNG is in [assets/app-icon.png](assets/app-icon.png), and the macOS icon is in [assets/Marcos.icns](assets/Marcos.icns).

