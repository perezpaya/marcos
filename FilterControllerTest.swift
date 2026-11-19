import AppKit
import ServiceManagement

@main
struct FilterControllerTest {
    @MainActor
    static func main() {
        let app = NSApplication.shared
        app.setActivationPolicy(.accessory)
        let screens = NSScreen.screens
        precondition(!screens.isEmpty, "Run in a logged-in macOS desktop session")

        let suite = "com.local.redfilter.test.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        let filter = FilterController(defaults: defaults)
        let menu = StatusMenu(filter: filter)
        let button = menu.item.button!
        let loginStatus = SMAppService.mainApp.status
        filter.applicationDidFinishLaunching(Notification(name: NSApplication.didFinishLaunchingNotification))
        precondition(SMAppService.mainApp.status == loginStatus)

        func visibleOverlays() -> [NSWindow] {
            app.windows.filter { $0.isVisible && $0.level == .screenSaver }
        }

        precondition(!filter.enabled && filter.strength == 45 && visibleOverlays().isEmpty)
        precondition(button.image?.isTemplate == true)
        button.performClick(nil)
        precondition(filter.enabled && visibleOverlays().count == screens.count)
        button.performClick(nil)
        precondition(!filter.enabled && visibleOverlays().isEmpty)
        filter.strength = 1
        filter.enabled = true
        precondition(visibleOverlays().count == screens.count)
        precondition(button.image?.isTemplate == false)
        let icon = NSBitmapImageRep(data: button.image!.tiffRepresentation!)!
        let iconPixels = (0..<icon.pixelsWide).flatMap { x in
            (0..<icon.pixelsHigh).compactMap { y in
                icon.colorAt(x: x, y: y)?.usingColorSpace(.sRGB)
            }
        }
        precondition(iconPixels.contains { $0.alphaComponent > 0.8 && $0.redComponent > $0.greenComponent + 0.3 })
        precondition(iconPixels.contains { $0.alphaComponent == 0 })
        for screen in screens {
            precondition(visibleOverlays().contains { $0.frame == screen.frame && $0.ignoresMouseEvents })
        }

        filter.strength = 2
        precondition(visibleOverlays().allSatisfy { abs($0.alphaValue - 0.0136) < 0.0001 })
        filter.applicationDidChangeScreenParameters(Notification(name: NSApplication.didChangeScreenParametersNotification))
        precondition(visibleOverlays().count == screens.count)
        let restored = FilterController(defaults: defaults)
        precondition(restored.enabled && restored.strength == 2)

        let originalWindows = visibleOverlays().map(\.windowNumber).sorted()
        let originalButtonWidth = button.frame.width
        filter.strength = 0
        precondition(!filter.enabled)
        precondition(visibleOverlays().isEmpty)
        precondition(button.image?.isTemplate == true)
        precondition(button.frame.width == originalButtonWidth)
        button.performClick(nil)
        precondition(filter.enabled && filter.strength == 2)
        precondition(visibleOverlays().map(\.windowNumber).sorted() == originalWindows)
        filter.strength = 0
        filter.strength = 2
        precondition(filter.enabled)
        precondition(visibleOverlays().count == screens.count)
        precondition(button.image?.isTemplate == false)

        let amber = NSColor(srgbRed: 0.8, green: 0.35, blue: 0.04, alpha: 1)
        filter.baseColor = amber
        precondition(visibleOverlays().allSatisfy { $0.backgroundColor == amber })
        let amberSettings = FilterController(defaults: defaults)
        precondition(amberSettings.baseColor == amber)
        filter.enabled = false
        precondition(visibleOverlays().isEmpty)
        precondition(button.image?.isTemplate == true)
        defaults.set([0.12, 0.36, 0.8], forKey: "baseColor")
        let oldBlueSettings = FilterController(defaults: defaults)
        precondition(oldBlueSettings.baseColor == FilterController.defaultColor)
        defaults.set([0.2, 0.3], forKey: "baseColor")
        defaults.set(0, forKey: "filterStrength")
        defaults.set(true, forKey: "filterEnabled")
        let legacyZero = FilterController(defaults: defaults)
        precondition(!legacyZero.enabled && legacyZero.baseColor == FilterController.defaultColor)
        legacyZero.enabled = true
        precondition(legacyZero.strength == 2 && legacyZero.enabled)
        legacyZero.enabled = false
        defaults.removeObject(forKey: "lastStrength")
        defaults.set(60, forKey: "filterStrength")
        let legacyStrength = FilterController(defaults: defaults)
        legacyStrength.strength = 0
        legacyStrength.enabled = true
        precondition(legacyStrength.strength == 60)
        legacyStrength.enabled = false
        print("Filter checks passed on \(screens.count) display(s).")
    }
}
