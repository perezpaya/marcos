import Combine
import ServiceManagement
import SwiftUI

@MainActor
final class StatusMenu: NSObject {
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let filter: FilterController
    private let popover = NSPopover()
    private var iconUpdates: AnyCancellable?

    private let clearGlasses = NSImage(systemSymbolName: "eyeglasses", accessibilityDescription: nil)
    private let redGlasses: NSImage? = {
        guard let symbol = NSImage(systemSymbolName: "sunglasses.fill", accessibilityDescription: nil) else {
            return nil
        }
        return NSImage(size: symbol.size, flipped: false) { bounds in
            symbol.draw(in: bounds)
            NSColor.systemRed.setFill()
            bounds.fill(using: .sourceAtop)
            return true
        }
    }()

    init(filter: FilterController) {
        self.filter = filter
        super.init()
        clearGlasses?.isTemplate = true
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: FilterControls(filter: filter))
        item.autosaveName = "Marcos"
        item.button?.target = self
        item.button?.action = #selector(handleClick)
        item.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        item.button?.toolTip = "Marcos · Click to toggle · Right-click for options"

        iconUpdates = filter.$enabled.combineLatest(filter.$strength)
            .map { enabled, strength in enabled && strength > 0 }
            .removeDuplicates()
            .sink { [weak self] active in
                guard let self, let button = item.button else { return }
                button.image = active ? redGlasses ?? clearGlasses : clearGlasses
                button.setAccessibilityLabel(active ? "Marcos, filter on" : "Marcos, filter off")
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

private struct FilterControls: View {
    @ObservedObject var filter: FilterController

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle("Red filter", isOn: $filter.enabled)
                .toggleStyle(.switch)
                .controlSize(.small)

            Slider(value: $filter.strength, in: 0...100, step: 1) {
                Text("Strength")
            }
            .accessibilityValue(Text(filter.strength / 100, format: .percent.precision(.fractionLength(0))))
            .disabled(!filter.enabled)

            Text(filter.strength / 100, format: .percent.precision(.fractionLength(0)))
                .monospacedDigit()
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .accessibilityHidden(true)

            Divider()

            if filter.loginNeedsAttention {
                Button("Open Login Items") {
                    SMAppService.openSystemSettingsLoginItems()
                }
                Text("Enable Marcos in Login Items to start it automatically.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button("Quit Marcos") { NSApp.terminate(nil) }
                .keyboardShortcut("q")
        }
        .padding(16)
        .frame(width: 260)
    }
}
