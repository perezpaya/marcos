import AppKit
import OSLog
import ServiceManagement

@MainActor
final class FilterController: NSObject, NSApplicationDelegate, ObservableObject {
    private let defaults: UserDefaults
    private let logger = Logger(subsystem: "com.local.redfilter", category: "Login")
    private var overlays: [NSWindow] = []

    @Published private(set) var loginNeedsAttention = false

    @Published var enabled: Bool {
        didSet {
            defaults.set(enabled, forKey: "filterEnabled")
            updateOverlays()
        }
    }

    @Published var strength: Double {
        didSet {
            defaults.set(strength, forKey: "filterStrength")
            updateOverlays()
        }
    }

    override convenience init() {
        self.init(defaults: .standard)
    }

    init(defaults: UserDefaults) {
        self.defaults = defaults
        enabled = defaults.bool(forKey: "filterEnabled")
        let savedStrength = defaults.object(forKey: "filterStrength") as? Double ?? 45
        strength = min(100, max(0, savedStrength))
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        updateOverlays()
        let loginItem = SMAppService.mainApp
        let initialStatus = loginItem.status
        if (initialStatus == .notRegistered || initialStatus == .notFound) &&
            !defaults.bool(forKey: "loginRegistered") {
            do {
                try loginItem.register()
            } catch {
                logger.error("Login item registration failed: \(error.localizedDescription, privacy: .public)")
            }
        }
        let status = loginItem.status
        loginNeedsAttention = status != .enabled
        if status == .enabled {
            defaults.set(true, forKey: "loginRegistered")
        }
        logger.info("Login item status: \(initialStatus.rawValue, privacy: .public) → \(status.rawValue, privacy: .public)")
    }

    func applicationDidChangeScreenParameters(_ notification: Notification) {
        removeOverlays()
        updateOverlays()
    }

    private func removeOverlays() {
        for overlay in overlays {
            overlay.orderOut(nil)
        }
        overlays.removeAll()
    }

    private func updateOverlays() {
        guard enabled, strength > 0 else {
            removeOverlays()
            return
        }

        // Leave enough contrast to read the screen at full strength.
        let opacity = strength / 100 * 0.68
        if overlays.isEmpty {
            overlays = NSScreen.screens.map { screen in
                let overlay = NSWindow(
                    contentRect: screen.frame,
                    styleMask: .borderless,
                    backing: .buffered,
                    defer: false
                )
                overlay.level = .screenSaver
                overlay.collectionBehavior = [
                    .canJoinAllSpaces, .stationary, .ignoresCycle,
                    .fullScreenAuxiliary, .canJoinAllApplications,
                ]
                overlay.isOpaque = true
                overlay.hasShadow = false
                overlay.ignoresMouseEvents = true
                overlay.backgroundColor = NSColor(srgbRed: 0.65, green: 0, blue: 0, alpha: 1)
                overlay.alphaValue = opacity
                overlay.orderFrontRegardless()
                return overlay
            }
        } else {
            for overlay in overlays {
                overlay.alphaValue = opacity
            }
        }
    }
}
