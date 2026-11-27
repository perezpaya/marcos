import AppKit
import SwiftUI

@main
struct NativeCapture {
    @MainActor static func main() {
        let app = NSApplication.shared
        app.setActivationPolicy(.prohibited)
        app.applicationIconImage = NSImage(contentsOfFile: CommandLine.arguments[1] + "/assets/Marcos.icns")!
        let output = URL(fileURLWithPath: CommandLine.arguments[2])
        try! FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
        var windows: [NSWindow] = []
        var views: [(String, NSHostingView<AnyView>)] = []
        for (name, index, strength, active, dark) in [
            ("red",0,45.0,true,false), ("orange",1,45.0,true,false), ("amber",2,45.0,true,false),
            ("red-dark",0,45.0,true,true), ("orange-dark",1,45.0,true,true), ("amber-dark",2,45.0,true,true),
            ("subtle",0,20.0,true,false), ("strong",0,80.0,true,false), ("off-dark",0,45.0,false,true)
        ] {
            let suite = "MarcosScreenshot.\(name).\(UUID().uuidString)"
            let defaults = UserDefaults(suiteName: suite)!
            let color = FilterController.colors[index].color
            defaults.set(strength, forKey: "filterStrength")
            defaults.set(active, forKey: "filterEnabled")
            defaults.set([color.redComponent,color.greenComponent,color.blueComponent], forKey: "baseColor")
            let filter = FilterController(defaults: defaults)
            let view = NSHostingView(rootView: AnyView(FilterControls(filter: filter).environment(\.controlActiveState, .key).environment(\.colorScheme, dark ? .dark : .light).background(dark ? Color(nsColor: NSColor(calibratedWhite: 0.12, alpha: 1)) : Color(nsColor: NSColor(calibratedWhite: 0.98, alpha: 1)))))
            view.appearance = NSAppearance(named: dark ? .darkAqua : .aqua)
            view.frame = NSRect(origin: .zero, size: view.fittingSize)
            let window = NSWindow(contentRect: view.frame, styleMask: .borderless, backing: .buffered, defer: false)
            window.contentView = view
            window.backgroundColor = dark ? NSColor(calibratedWhite: 0.12, alpha: 1) : NSColor(calibratedWhite: 0.98, alpha: 1)
            windows.append(window)
            views.append((name,view))
            defaults.removePersistentDomain(forName: suite)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            for (name,view) in views {
                view.layoutSubtreeIfNeeded()
                let rep = view.bitmapImageRepForCachingDisplay(in: view.bounds)!
                view.effectiveAppearance.performAsCurrentDrawingAppearance {
                    view.cacheDisplay(in: view.bounds, to: rep)
                }
                try! rep.representation(using: .png, properties: [:])!.write(to: output.appendingPathComponent(name + ".png"))
                print(name, view.bounds.size, rep.pixelsWide, rep.pixelsHigh)
            }
            withExtendedLifetime(windows) { app.terminate(nil) }
        }
        app.run()
    }
}
