import AppKit

@main
enum MarcosApp {
    @MainActor
    static func main() {
        let app = NSApplication.shared
        let filter = FilterController()
        let menu = StatusMenu(filter: filter)
        app.delegate = filter
        withExtendedLifetime((filter, menu)) { app.run() }
    }
}
