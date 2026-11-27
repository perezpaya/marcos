# Marcos App Store submission

## Release build

Version 1.2.3, build 6. The release target uses bundle identifier `com.perezpaya.marcos`, App Sandbox, and hardened runtime. It builds for Apple silicon and Intel Macs running macOS 13 or later.

Open `Marcos.xcodeproj`, select the Marcos target, and choose the publishing Apple Developer team in Signing & Capabilities. The checked-in project is ready to open in Xcode. `project.yml` is its XcodeGen source.

The Mac App Store bundle has its own sandbox container and preferences. Preferences from the locally installed `com.local.redfilter` build are separate.

A universal sandboxed archive and App Store distribution-signed package were built on November 27, 2026 using the personal developer team. Signature integrity and sandbox entitlements passed local checks. Apple processed build 6, and version 1.2.3 was submitted on November 27, 2026. Its verified status is Waiting for Review; automatic release after approval is selected. See [build status](Preview/BuildStatus.md).

## Submitted listing

**Name** Marcos: Screen Tint

**Subtitle** Warm colors. One click away.

**Category** Utilities

**Price** Free

The revised product description, promotional text, keyword field, distribution intent, and review notes are in [the submitted listing](Preview/Listing.md) and [structured metadata](Preview/metadata.en-US.json). These supersede the earlier proposed copy. The listing and all five screenshots were submitted to Apple.

**Support URL** https://github.com/perezpaya/marcos/issues

**Privacy policy URL** https://github.com/perezpaya/marcos/blob/main/PRIVACY.md

**Copyright** 2026 Alejandro Perezpayá

## Screenshots

The new five-image campaign is in [the review gallery](Preview/index.html). All exports are 2880 × 1800 sRGB JPEGs, using a labeled physical MacBook render for the first image and captures of the production SwiftUI controls with labeled original desktop illustrations for images 2–5. The user approved the revised MacBook screenshot and requested publication on November 27, 2026. No further screenshot approval is needed. The submission is Waiting for Review. The older `Screenshots/01-controls-light.jpg` and `Screenshots/02-controls-dark.jpg` remain available for the existing GitHub README.

## Privacy and review

The published App Privacy response is Data Not Collected. The app has no network entitlement and contains no analytics or third-party SDKs. Its privacy manifest declares local preference access using reason CA92.1.

Reviewer notes should explain that Marcos runs in the menu bar without a Dock icon. Left-click the glasses to toggle the filter. Right-click or Control-click to open options. Launch at login is opt-in. No account or special hardware is required.

The age-rating questionnaire, private review contact, pricing, availability, and user-confirmed content-rights declaration are saved in App Store Connect. The general-audience rating is 4+ with regional equivalents. Pricing is free in all 175 current countries and regions, including future territories.

## Signing and upload

Use the approved personal developer team when signing. Archive through Xcode Organizer or run the following commands with its team identifier. Do not switch to a company team. The current build has been submitted; the commands below describe rebuilding for future submissions.

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
