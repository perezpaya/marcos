import AppKit
import OSLog
import ServiceManagement

@MainActor
final class FilterController: NSObject, NSApplicationDelegate, ObservableObject {
    static let defaultColor = NSColor(srgbRed: 0.65, green: 0, blue: 0, alpha: 1)
    private let defaults: UserDefaults
    private let logger = Logger(subsystem: "com.local.redfilter", category: "Login")
    private var overlays: [NSWindow] = []

    @Published private(set) var loginNeedsAttention = false

    @Published var enabled: Bool {
        didSet {
            if enabled && strength == 0 {
                let saved = defaults.double(forKey: "lastStrength")
                strength = saved.isFinite && saved > 0 ? min(100, saved) : 45
            }
            defaults.set(enabled, forKey: "filterEnabled")
            updateOverlays()
        }
    }

    @Published var strength: Double {
        didSet {
            defaults.set(strength, forKey: "filterStrength")
            if strength > 0 {
                defaults.set(strength, forKey: "lastStrength")
            }
            if enabled != (strength > 0) {
                enabled = strength > 0
            }
            updateOverlays()
        }
    }

    @Published var baseColor: NSColor {
        didSet {
            let rgb = baseColor.usingColorSpace(.sRGB) ?? Self.defaultColor
            defaults.set([rgb.redComponent, rgb.greenComponent, rgb.blueComponent], forKey: "baseColor")
            updateOverlays()
        }
    }

    override convenience init() {
        self.init(defaults: .standard)
    }

    init(defaults: UserDefaults) {
        self.defaults = defaults
        let savedStrength = defaults.object(forKey: "filterStrength") as? Double ?? 45
        strength = savedStrength.isFinite ? min(100, max(0, savedStrength)) : 45
        enabled = defaults.bool(forKey: "filterEnabled") && savedStrength > 0
        if let rgb = defaults.array(forKey: "baseColor") as? [Double],
           rgb.count == 3, rgb.allSatisfy({ $0.isFinite && (0...1).contains($0) }) {
            baseColor = NSColor(srgbRed: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1)
        } else {
            baseColor = Self.defaultColor
        }
        super.init()
        if strength > 0 {
            defaults.set(strength, forKey: "lastStrength")
        }
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
            overlay.close()
        }
        overlays.removeAll()
    }

    private func updateOverlays() {
        guard enabled, strength > 0 else {
            for overlay in overlays {
                overlay.orderOut(nil)
            }
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
                overlay.isReleasedWhenClosed = false
                overlay.hasShadow = false
                overlay.animationBehavior = .none
                overlay.ignoresMouseEvents = true
                overlay.backgroundColor = baseColor.withAlphaComponent(1)
                overlay.alphaValue = opacity
                overlay.orderFrontRegardless()
                return overlay
            }
        } else {
            for overlay in overlays {
                overlay.backgroundColor = baseColor.withAlphaComponent(1)
                overlay.alphaValue = opacity
                if !overlay.isVisible {
                    overlay.orderFrontRegardless()
                }
            }
        }
    }
}
