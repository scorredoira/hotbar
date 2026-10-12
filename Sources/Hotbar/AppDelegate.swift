import AppKit
import Carbon.HIToolbox
import ServiceManagement

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        HotKey.register(keyCode: kVK_F15) { Windows.cycleFrontApp() }
        if SMAppService.mainApp.status != .enabled {
            try? SMAppService.mainApp.register()
        }
        Windows.requestAccess()
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.image = NSImage(systemSymbolName: "bolt.horizontal", accessibilityDescription: "Hotbar")

        let menu = NSMenu()
        let cycle = menu.addItem(withTitle: "Cycle Windows", action: #selector(cycleWindows), keyEquivalent: "")
        cycle.image = NSImage(systemSymbolName: "macwindow.on.rectangle", accessibilityDescription: nil)
        cycle.toolTip = "F15"
        let screen = menu.addItem(withTitle: "Turn Off Screen", action: #selector(turnOffScreen), keyEquivalent: "")
        screen.image = NSImage(systemSymbolName: "display", accessibilityDescription: nil)
        let sleep = menu.addItem(withTitle: "Sleep", action: #selector(sleepMac), keyEquivalent: "")
        sleep.image = NSImage(systemSymbolName: "moon", accessibilityDescription: nil)
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit Hotbar", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        for item in menu.items where item.action != #selector(NSApplication.terminate(_:)) {
            item.target = self
        }
        statusItem.menu = menu
    }

    @objc private func cycleWindows() {
        NSApp.hide(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { Windows.cycleFrontApp() }
    }

    @objc private func turnOffScreen() {
        Power.run("displaysleepnow")
    }

    @objc private func sleepMac() {
        Power.run("sleepnow")
    }
}
