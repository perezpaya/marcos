import Combine
import ServiceManagement
import SwiftUI

@MainActor
final class StatusMenu: NSObject {
    let item = NSStatusBar.system.statusItem(withLength: 34)
    private let filter: FilterController
    private let popover = NSPopover()
    private var iconUpdates: AnyCancellable?

    private static func glasses(color: NSColor?) -> NSImage {
        let image = NSImage(size: NSSize(width: 26, height: 16), flipped: false) { _ in
            for x in [CGFloat(2), CGFloat(15)] {
                let lens = NSBezierPath(roundedRect: NSRect(x: x, y: 3, width: 9, height: 9), xRadius: 2.5, yRadius: 2.5)
                color?.setFill()
                if color != nil { lens.fill() }
                NSColor.labelColor.setStroke()
                lens.lineWidth = 1.6
                lens.stroke()
            }
            let frame = NSBezierPath()
            frame.move(to: NSPoint(x: 11, y: 8))
            frame.curve(to: NSPoint(x: 15, y: 8), controlPoint1: NSPoint(x: 12, y: 10), controlPoint2: NSPoint(x: 14, y: 10))
            frame.move(to: NSPoint(x: 0.5, y: 11))
            frame.line(to: NSPoint(x: 2, y: 10))
            frame.move(to: NSPoint(x: 24, y: 10))
            frame.line(to: NSPoint(x: 25.5, y: 11))
            frame.lineWidth = 1.6
            frame.stroke()
            return true
        }
        image.isTemplate = color == nil
        return image
    }

    init(filter: FilterController) {
        self.filter = filter
        super.init()
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: FilterControls(filter: filter))
        item.autosaveName = "Marcos"
        item.button?.target = self
        item.button?.action = #selector(handleClick)
        item.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        item.button?.toolTip = "Marcos · Click to toggle · Right-click for options"

        iconUpdates = filter.$enabled.combineLatest(filter.$strength, filter.$baseColor)
            .map { enabled, strength, color in enabled && strength > 0 ? color : nil }
            .removeDuplicates { $0 == $1 }
            .sink { [weak self] color in
                guard let self, let button = item.button else { return }
                button.image = Self.glasses(color: color)
                button.setAccessibilityLabel(color != nil ? "Marcos, filter on" : "Marcos, filter off")
            }
    }

    @objc private func handleClick() {
        let event = NSApp.currentEvent
        let opensOptions = event?.type == .rightMouseUp ||
            event?.modifierFlags.contains(.control) == true
        guard opensOptions else {
            popover.performClose(nil)
            filter.enabled.toggle()
            return
        }
        guard let button = item.button else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}

struct FilterControls: View {
    @ObservedObject var filter: FilterController

    private let colors: [(name: String, color: NSColor)] = [
        ("Red", .init(srgbRed: 0.65, green: 0, blue: 0, alpha: 1)),
        ("Amber", .init(srgbRed: 0.8, green: 0.35, blue: 0.04, alpha: 1)),
        ("Green", .init(srgbRed: 0.12, green: 0.52, blue: 0.3, alpha: 1)),
        ("Blue", .init(srgbRed: 0.12, green: 0.36, blue: 0.8, alpha: 1)),
        ("Violet", .init(srgbRed: 0.5, green: 0.22, blue: 0.75, alpha: 1)),
    ]

    private var tint: Color { Color(nsColor: filter.baseColor) }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 12) {
                Image(nsImage: NSApplication.shared.applicationIconImage)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Marcos")
                        .font(.system(size: 19, weight: .semibold))
                    Text(filter.enabled ? "On · All displays" : "Filter off")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Toggle("Screen tint", isOn: $filter.enabled)
                    .labelsHidden()
                    .toggleStyle(.switch)
                    .tint(tint)
            }

            VStack(spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Strength")
                        .font(.system(size: 13, weight: .medium))
                    Spacer()
                    Text(filter.strength / 100, format: .percent.precision(.fractionLength(0)))
                        .font(.system(size: 27, weight: .medium, design: .rounded))
                        .monospacedDigit()
                        .accessibilityHidden(true)
                }
                Slider(value: Binding(
                    get: { filter.strength },
                    set: { filter.strength = $0.rounded() }
                ), in: 0...100) {
                    Text("Strength")
                }
                .labelsHidden()
                .tint(tint)
                .accessibilityValue(Text(filter.strength / 100, format: .percent.precision(.fractionLength(0))))

                HStack {
                    Text("Clear")
                    Spacer()
                    Text("Full tint")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            }
            .padding(16)
            .background(.primary.opacity(0.04), in: RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Base color")
                        .font(.system(size: 13, weight: .medium))
                    Spacer()
                    ColorPicker("Custom color", selection: Binding(
                        get: { tint },
                        set: { filter.baseColor = NSColor($0) }
                    ), supportsOpacity: false)
                    .font(.caption)
                }

                HStack(spacing: 12) {
                    ForEach(colors, id: \.name) { preset in
                        let selected = filter.baseColor.usingColorSpace(.sRGB) == preset.color
                        Button {
                            filter.baseColor = preset.color
                        } label: {
                            Circle()
                                .fill(Color(nsColor: preset.color))
                                .frame(width: 34, height: 34)
                                .overlay {
                                    if selected {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundStyle(.white)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(preset.name)
                        .accessibilityAddTraits(selected ? .isSelected : [])
                        .help(preset.name)
                    }
                }
            }

            Divider()

            Toggle("Launch at login", isOn: Binding(
                get: { filter.launchAtLogin },
                set: { filter.setLaunchAtLogin($0) }
            ))
            .toggleStyle(.switch)
            .controlSize(.small)

            if filter.loginNeedsAttention {
                Button("Open Login Items") {
                    SMAppService.openSystemSettingsLoginItems()
                }
                Text("Enable Marcos in Login Items to start it automatically.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let error = filter.loginError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack {
                Link("Privacy policy", destination: URL(string: "https://github.com/perezpaya/marcos/blob/main/PRIVACY.md")!)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer(minLength: 8)
                Button {
                    NSApp.terminate(nil)
                } label: {
                    Image(systemName: "power")
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Quit Marcos")
                .help("Quit Marcos")
                .keyboardShortcut("q")
            }
        }
        .padding(20)
        .frame(width: 320)
    }
}
