import AppKit

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

        filter.strength = 0
        precondition(visibleOverlays().isEmpty)
        precondition(button.image?.isTemplate == true)
        filter.strength = 2
        precondition(visibleOverlays().count == screens.count)
        precondition(button.image?.isTemplate == false)
        filter.enabled = false
        precondition(visibleOverlays().isEmpty)
        precondition(button.image?.isTemplate == true)
        print("Filter checks passed on \(screens.count) display(s).")
    }
}
