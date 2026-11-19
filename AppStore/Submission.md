# Marcos App Store submission

## Release build

Version 1.2.1, build 4. The release target uses bundle identifier `com.perezpaya.marcos`, App Sandbox, and hardened runtime. It builds for Apple silicon and Intel Macs running macOS 13 or later.

Open `Marcos.xcodeproj`, select the Marcos target, and choose the publishing Apple Developer team in Signing & Capabilities. The checked-in project is ready to open in Xcode. `project.yml` is its XcodeGen source.

The Mac App Store bundle has its own sandbox container and preferences. Preferences from the locally installed `com.local.redfilter` build are separate.

An unsigned archive has been built locally. Distribution signing, an App Store provisioning profile, an App Store Connect app record, and Apple review remain pending.

## Proposed listing

**Name** Marcos

**Subtitle** Screen tint, one click away

**Category** Utilities

**Price** Free

**Description**

Give your displays a color tint from the menu bar.

Click the glasses to turn the tint on or off. Right-click to choose a base color and adjust its strength. Use one of five presets or choose a custom color.

Marcos applies the tint across your connected displays and remembers your settings. Sliding to 0% turns the tint off. Your next toggle restores the previous strength. Enable Launch at login to keep Marcos ready when you sign in.

The menu bar glasses show your selected color while the tint is active and clear lenses when it is off.

Marcos works locally on your Mac, with no accounts, advertising, tracking, or analytics.

**Keywords** screen,tint,color,filter,red,menu bar,display,night,brightness,overlay

**Support URL** https://github.com/perezpaya/marcos/issues

**Privacy policy URL** https://github.com/perezpaya/marcos/blob/main/PRIVACY.md

**Copyright** 2026 Alejandro Perezpayá

## Screenshots

`Screenshots/01-controls-light.jpg` and `Screenshots/02-controls-dark.jpg` contain native UI captures on neutral backgrounds. Both use Apple's accepted 2880 × 1800 Mac screenshot dimensions.

## Privacy and review

The proposed App Privacy response is Data Not Collected. The app has no network entitlement and contains no analytics or third-party SDKs. Its privacy manifest declares local preference access using reason CA92.1.

Reviewer notes should explain that Marcos runs in the menu bar without a Dock icon. Left-click the glasses to toggle the filter. Right-click or Control-click to open options. Launch at login is opt-in. No account or special hardware is required.

The age-rating questionnaire, review contact details, distribution territories, final pricing, and content-rights declaration must be completed in App Store Connect. The content-rights declaration must accurately cover the portrait icon and its source reference.

## Signing and upload

After approval to create or update App IDs, certificates, and provisioning profiles in the selected Apple Developer account, archive through Xcode Organizer or run the following commands with the publishing team identifier.

```sh
xcodebuild -project Marcos.xcodeproj -scheme Marcos \
  -configuration Release -destination 'generic/platform=macOS' \
  -archivePath build/AppStore/Marcos.xcarchive \
  -allowProvisioningUpdates DEVELOPMENT_TEAM=YOUR_TEAM_ID archive

xcodebuild -exportArchive -archivePath build/AppStore/Marcos.xcarchive \
  -exportPath build/AppStore/export \
  -exportOptionsPlist AppStore/ExportOptions.plist \
  -allowProvisioningUpdates
```

The export options produce a signed package for App Store Connect. Upload it through Xcode Organizer or Transporter, select the processed build in the app record, complete the listing and declarations, and submit to Apple for review.
